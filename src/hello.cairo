#[starknet::contract]
mod HelloStarknet {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use crate::IHello::IHelloStarknet;
    use crate::INumber::INumber;

    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[generate_trait]
    impl InternalTrait of InternalImpl {
        fn _add(ref self: ContractState, amount: felt252) {
            let old_balance = self.balance.read();
            self.balance.write(old_balance + amount);
        }

        fn _subtract(ref self: ContractState, amount: felt252) {
            let old_balance = self.balance.read();
            self.balance.write(old_balance - amount);
        }
    }

    fn add(amount: felt252) -> felt252 {
        amount + 2
    }


    #[abi(embed_v0)]
    impl HelloStarknet of IHelloStarknet<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            let upgraded_score = add(amount);
            self._add(upgraded_score);
        }

        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }

        fn add_and_subtract(ref self: ContractState, amount: felt252) {
            self._add(amount);
            self._subtract(amount);
        }
    }

    #[abi(embed_v0)]
    impl INumberImpl of INumber<ContractState> {
        fn set_number(ref self: ContractState, amount: u8) {}
        fn get_number(self: @ContractState) -> u8 {
            let number: u8 = 8;
            number
        }
    }
}
