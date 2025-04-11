use starknet::ContractAddress;

#[starknet::interface]
pub trait ISimpleBank<TContractState> {
    fn open_account(ref self: TContractState, name: ByteArray);
    fn deposit(ref self: TContractState, amount: u128);
    fn withdraw(ref self: TContractState, amount: u128);
    fn transfer(ref self: TContractState, amount: u128, recipient: ContractAddress);
    fn get_balance(self: @TContractState) -> u128;
    fn close_account(ref self: TContractState, recipient: ContractAddress);
}

#[derive(Clone, Debug, Drop, PartialEq, Serde, starknet::Store)]
pub struct BankAccount {
    name: ByteArray,
    address: ContractAddress,
    balance: u128,
}

#[starknet::contract]
pub mod SimpleBank {
    use starknet::event::EventEmitter;
    use starknet::get_caller_address;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use super::*;

    #[storage]
    struct Storage {
        names: Map<ContractAddress, ByteArray>,
        balances: Map<ContractAddress, u128>,
        account_status: Map<ContractAddress, bool>,
    }

    #[event]
    #[derive(Debug, Clone, Drop, starknet::Event)]
    pub enum Event {
        AccountCreated: AccountCreated,
        DepositMade: DepositMade,
        WithdrawalMade: WithdrawalMade,
        TransferMade: TransferMade,
        AccountClosed: AccountClosed,
    }

    #[derive(Clone, Drop, Debug, starknet::Event)]
    pub struct AccountCreated {
        name: ByteArray,
        address: ContractAddress,
        balance: u128,
    }

    #[derive(Clone, Drop, Debug, starknet::Event)]
    pub struct DepositMade {
        amount: u128,
        address: ContractAddress,
    }

    #[derive(Clone, Drop, Debug, starknet::Event)]
    pub struct WithdrawalMade {
        amount: u128,
        address: ContractAddress,
    }

    #[derive(Clone, Drop, Debug, starknet::Event)]
    pub struct TransferMade {
        amount: u128,
        from: ContractAddress,
        to: ContractAddress,
    }

    #[derive(Clone, Drop, Debug, starknet::Event)]
    pub struct AccountClosed {
        address: ContractAddress,
        recipient: ContractAddress,
        final_balance: u128,
    }

    #[abi(embed_v0)]
    impl ISimpleBankImpl of ISimpleBank<ContractState> {
        fn open_account(ref self: ContractState, name: ByteArray) {
            let address = get_caller_address();
            self.names.write(address, name.clone());
            self.balances.write(address, 0);
            self.account_status.write(address, true);
            self.emit(Event::AccountCreated(AccountCreated { name, address, balance: 0 }));
        }

        fn deposit(ref self: ContractState, amount: u128) {
            let address = get_caller_address();
            // Check if account is active
            assert(self.account_status.read(address), 'Account is closed');

            let balance: u128 = self.balances.read(address);

            let new_balance = balance + amount;

            self.balances.write(address, new_balance);
            self.emit(Event::DepositMade(DepositMade { amount, address }))
        }

        fn withdraw(ref self: ContractState, amount: u128) {
            let address = get_caller_address();

            // Check if account is active
            assert(self.account_status.read(address), 'Account is closed');

            let balance: u128 = self.balances.read(address);

            // Check if there's enough balance
            assert(balance >= amount, 'Insufficient balance');

            let new_balance = balance - amount;

            self.balances.write(address, new_balance);
            self.emit(Event::WithdrawalMade(WithdrawalMade { amount, address }))
        }

        fn transfer(ref self: ContractState, amount: u128, recipient: ContractAddress) {
            let from = get_caller_address();

            // Check if sender account is active
            assert(self.account_status.read(from), 'Account is closed');

            // Check if recipient account is active
            assert(self.account_status.read(recipient), 'Recipient account is closed');

            let balance_from = self.balances.read(from);

            // Check if there's enough balance
            assert(balance_from >= amount, 'Insufficient balance');

            let balance_to = self.balances.read(recipient);

            let balance_from_new_amount = balance_from - amount;
            let balance_to_new_amount = balance_to + amount;

            self.balances.write(from, balance_from_new_amount);
            self.balances.write(recipient, balance_to_new_amount);

            self.emit(Event::TransferMade(TransferMade { amount, from, to: recipient }))
        }

        fn close_account(ref self: ContractState, recipient: ContractAddress) {
            let address = get_caller_address();

            // Check if account is active
            assert(self.account_status.read(address), 'Account is closed');

            // Check if recipient account is active
            assert(self.account_status.read(recipient), 'Recipient account is closed');

            // Transfer remaining balance if any
            let balance = self.balances.read(address);
            if balance > 0 {
                let recipient_balance = self.balances.read(recipient);
                self.balances.write(recipient, recipient_balance + balance);
                self.balances.write(address, 0);
            }

            // Mark account as closed
            self.account_status.write(address, false);

            // Emit event
            self
                .emit(
                    Event::AccountClosed(
                        AccountClosed { address, recipient, final_balance: balance },
                    ),
                );
        }


        fn get_balance(self: @ContractState) -> u128 {
            self.balances.read(get_caller_address())
        }
    }
}
