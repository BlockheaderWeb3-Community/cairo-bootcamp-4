#[starknet::interface]
pub trait IAggregator<TContractState> {
    // Increase contract count.
    fn increase_count(ref self: TContractState, amount: u32);
    // Increase counter count
    fn increase_counter_count(ref self: TContractState, amount: u32);
    // Retrieve contract count.
    fn decrease_count_by_one(ref self: TContractState);
    // Retrieve contract count.
    fn get_count(self: @TContractState) -> u32;
    // Activate the switch
    fn activate_switch(ref self: TContractState);
}

/// Simple contract for managing count.
#[starknet::contract]
pub mod Aggregator {
    use cohort_4::counter::{ICounterDispatcher, ICounterDispatcherTrait};
    use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
    use cohort_4::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
    use core::num::traits::Zero;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address};
    use crate::events::*;
    use super::*;

    #[storage]
    struct Storage {
        count: u32,
        counter: ContractAddress,
        killswitch: ContractAddress,
        ownable: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct CountIncreased {
        pub new_count: u32,
        pub caller: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct CounterCountIncreased {
        pub new_counter: u32,
        pub caller: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct CountDecreasedByOne {
        pub new_count: u32,
        pub caller: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct SwitchStatus {
        pub status: bool,
        pub caller: ContractAddress,
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        CountIncreased: CountIncreased,
        CounterCountIncreased: CounterCountIncreased,
        CountDecreasedByOne: CountDecreasedByOne,
        SwitchStatus: SwitchStatus,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        counter: ContractAddress,
        killswitch: ContractAddress,
        ownable: ContractAddress,
    ) {
        //Validate the addresses to be sure
        self.validate_contract_addresses(counter, killswitch, ownable);

        self.counter.write(counter);
        self.killswitch.write(killswitch);
        self.ownable.write(ownable);
    }

    #[abi(embed_v0)]
    impl AggregatorImpl of super::IAggregator<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            // Check ownership with internal function
            self.assert_only_owner();
            assert(amount > 0, 'Amount cannot be 0');

            let counter = ICounterDispatcher { contract_address: self.counter.read() };
            let counter_count = counter.get_count();
            let new_count = counter_count + amount;
            self.count.write(new_count);

            self.emit(CountIncreased { new_count: amount, caller: get_caller_address() });
        }

        fn increase_counter_count(ref self: ContractState, amount: u32) {
            // Check ownership with internal function

            self.assert_only_owner();

            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };
            assert(killswitch.get_status(), 'Oops! Switch is off');
            ICounterDispatcher { contract_address: self.counter.read() }.increase_count(amount);
            self.emit(CounterCountIncreased { new_counter: amount, caller: get_caller_address() });
        }

        fn decrease_count_by_one(ref self: ContractState) {
            // Check ownership with internal function
            self.assert_only_owner();

            let current_count = self.get_count();
            assert(current_count != 0, 'Count cannot be 0');
            let new_count1 = current_count - 1;
            self.count.write(new_count1);

            self.emit(CountDecreasedByOne { new_count: new_count1, caller: get_caller_address() });
        }

        fn activate_switch(ref self: ContractState) {
            self.assert_only_owner();

            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };

            if !killswitch.get_status() {
                killswitch.switch()
            }

            self.emit(SwitchStatus { status: true, caller: get_caller_address() });
        }

        fn get_count(self: @ContractState) -> u32 {
            self.assert_only_owner();
            self.count.read()
        }
    }

    #[generate_trait]
    impl OwnerHelpers of OwnersHelpersTrait {
        //check owner is caller
        fn assert_only_owner(self: @ContractState) {
            let caller = get_caller_address();
            // Dispatcher to interact with contract
            let ownable = IOwnableDispatcher { contract_address: self.ownable.read() };
            let owner = ownable.get_owner();
            assert(caller == owner, 'Caller is not owner');
        }

        fn validate_contract_addresses(
            self: @ContractState,
            counter: ContractAddress,
            killswitch: ContractAddress,
            ownable: ContractAddress,
        ) {
            //check that none is address zero
            assert(counter.is_non_zero(), 'Counter address cannot be 0');
            assert(killswitch.is_non_zero(), 'KillSwitch address cannot be 0');
            assert(ownable.is_non_zero(), 'Ownable address cannot be 0');

            //check there is no duplicate
            assert(counter != killswitch, 'counter cant be killswitch');
            assert(counter != ownable, 'counter cant be ownable');
            assert(killswitch != ownable, 'killswitch cant be ownable');
        }
    }
}
