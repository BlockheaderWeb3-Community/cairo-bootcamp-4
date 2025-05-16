#[starknet::contract]
mod Agggregator {
    use cohort_4::interfaces::Iaggregator::IAggregator;
    use cohort_4::interfaces::Icounter::{ICounterDispatcher, ICounterDispatcherTrait};
    use cohort_4::interfaces::Ikillswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
    use cohort_4::interfaces::Iowner::{IOwnerDispatcher, IOwnerDispatcherTrait};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address};


    #[storage]
    struct Storage {
        count: u32,
        counter: ContractAddress,
        killswitch: ContractAddress,
        ownable: ContractAddress,
    }


    #[constructor]
    fn constructor(
        ref self: ContractState,
        counter: ContractAddress,
        killswitch: ContractAddress,
        ownable: ContractAddress,
    ) {
        assert(counter != killswitch && counter != ownable, 'use counter address');
        assert(killswitch != counter && killswitch != ownable, 'use killswitch address');
        assert(ownable != killswitch && ownable != counter, 'use counter address');
        self.counter.write(counter);
        self.killswitch.write(killswitch);
        self.ownable.write(ownable);
    }


    #[abi(embed_v0)]
    impl AggregatorImpl of IAggregator<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            self.check_for_owner();
            assert(amount > 0, 'Amount cannot be 0');
            let counter = ICounterDispatcher { contract_address: self.counter.read() };
            let counter_count = counter.get_count();
            self.count.write(counter_count + amount);
        }

        fn increase_counter_count(ref self: ContractState, amount: u32) {
            self.check_for_owner();
            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };
            assert(killswitch.get_status(), 'should be active');
            ICounterDispatcher { contract_address: self.counter.read() }.increase_count(amount)
        }

        fn decrease_count_by_one(ref self: ContractState) {
            self.check_for_owner();
            let current_count = self.get_count();
            assert!(current_count != 0, "Amount cannot be 0");
            self.count.write(current_count - 1);
        }

        fn activate_switch(ref self: ContractState) {
            self.check_for_owner();

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


    #[generate_trait]
    impl privateAggregator of privateAggregatorTrait {
        fn check_for_owner(self: @ContractState) {
            let caller = get_caller_address();

            let ownable = IOwnerDispatcher { contract_address: self.ownable.read() };
            let owner = ownable.get_owner();
            assert(caller == owner, 'you are not the owner');
        }
    }
}
