#[starknet::interface]
pub trait IAggregator<TContractState> {
    /// Increase contract count.
    fn increase_count(ref self: TContractState, amount: u32);
    /// Increase contract count.
    ///
    fn increase_counter_count(ref self: TContractState, amount: u32);

    /// Retrieve contract count.
    fn decrease_count_by_one(ref self: TContractState);
    /// Retrieve contract count.
    fn get_count(self: @TContractState) -> u32;

    fn activate_switch(ref self: TContractState);
}

/// Simple contract for managing count.
#[starknet::contract]
mod Agggregator {
    use cohort_4::counter::{ICounterDispatcher, ICounterDispatcherTrait};
    use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};


    #[storage]
    struct Storage {
        count: u32,
        counter: ContractAddress,
        killswitch: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, counter: ContractAddress, killswitch: ContractAddress) {
        self.counter.write(counter);
        self.killswitch.write(killswitch);
    }


    #[abi(embed_v0)]
    impl AggregatorImpl of super::IAggregator<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            assert(amount > 0, 'Amount cannot be 0');
            let counter = ICounterDispatcher { contract_address: self.counter.read() };
            let counter_count = counter.get_count();
            self.count.write(counter_count + amount);
        }

        fn increase_counter_count(ref self: ContractState, amount: u32) {
            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };
            assert(killswitch.get_status(), 'should be active');
            ICounterDispatcher { contract_address: self.counter.read() }.increase_count(amount)
        }

        fn decrease_count_by_one(ref self: ContractState) {
            let current_count = self.get_count();
            assert!(current_count != 0, "Amount cannot be 0");
            self.count.write(current_count - 1);
        }

        fn activate_switch(ref self: ContractState) {
            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };

            if !killswitch.get_status() {
                killswitch.switch()
            }
        }

        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
    }
}
