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
    use core::num::traits::Zero;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};


    #[storage]
    struct Storage {
        count: u32,
        counter: ContractAddress,
        killswitch: ContractAddress,
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        CountIncreased: CountIncreased,
        CounterCountIncreased: CounterCountIncreased,
        CountDecreasedByOne: CountDecreasedByOne,
        SwitchStatus: SwitchStatus,
    }

    #[derive(Drop, Serde, starknet::Event)]
    pub struct CountIncreased {
        amount: u32,
    }

    #[derive(Drop, Serde, starknet::Event)]
    pub struct CounterCountIncreased {
        amount: u32,
    }

    #[derive(Drop, Serde, starknet::Event)]
    pub struct CountDecreasedByOne {
        pub previous_count: u32,
    }

    #[derive(Drop, Serde, starknet::Event)]
    pub struct SwitchStatus {
        pub get_status: bool,
    }

    #[constructor]
    fn constructor(ref self: ContractState, counter: ContractAddress, killswitch: ContractAddress) {
        self.counter.write(counter);
        self.killswitch.write(killswitch);
        //Assert address is not 0
        assert(!self.counter.read().is_zero(), 'Counter address cannot be 0');
        assert(!self.killswitch.read().is_zero(), 'KillSwitch address cannot be 0');
        //Assert count is not kill_switch
        assert(
            self.counter.read() != self.killswitch.read(),
            'Odd! Counter is KillSwitch'
        );
    }


    #[abi(embed_v0)]
    impl AggregatorImpl of super::IAggregator<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            assert(amount > 0, 'Amount cannot be 0');
            let counter = ICounterDispatcher { contract_address: self.counter.read() };
            let counter_count = counter.get_count();
            self.count.write(counter_count + amount);
            self.emit(CountIncreased { amount });
        }

        fn increase_counter_count(ref self: ContractState, amount: u32) {
            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };
            assert(killswitch.get_status(), 'should be active');
            ICounterDispatcher { contract_address: self.counter.read() }.increase_count(amount);
            self.emit(CounterCountIncreased { amount });
        }

        fn decrease_count_by_one(ref self: ContractState) {
            let current_count = self.get_count();
            assert!(current_count != 0, "Amount cannot be 0");
            self.count.write(current_count - 1);
            self.emit(CountDecreasedByOne { previous_count: current_count });
        }

        fn activate_switch(ref self: ContractState) {
            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };

            if !killswitch.get_status() {
                killswitch.switch()
            }
            self.emit(SwitchStatus { get_status: true });
        }

        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
    }
}
