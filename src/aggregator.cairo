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
pub mod Agggregator {
    use cohort_4::IOwnable::{IOwnableDispatcher, IOwnableDispatcherTrait};
    use cohort_4::counter::{ICounterDispatcher, ICounterDispatcherTrait};
    use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address};


    #[storage]
    struct Storage {
        count: u32,
        counter: ContractAddress,
        killswitch: ContractAddress,
        ownable_address: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
   pub enum Event {
        increased_aggregator_count: increased_aggregator_count,
        decreased_aggregator_count: decreased_aggregator_count,
    }


    #[derive(Drop, starknet::Event)]
    pub struct increased_aggregator_count {
        pub amount: u32,
        pub caller_address: ContractAddress,
    }


    #[derive(Drop, starknet::Event)]
    pub struct decreased_aggregator_count {
        pub amount: u32,
        pub caller_address: ContractAddress,
    }


    #[constructor]
    fn constructor(
        ref self: ContractState,
        counter: ContractAddress,
        killswitch: ContractAddress,
        ownable_address: ContractAddress,
    ) {
        self.__validator(counter, killswitch, ownable_address);

        self.counter.write(counter);
        self.killswitch.write(killswitch);
        self.ownable_address.write(ownable_address);
    }


    #[abi(embed_v0)]
    impl AggregatorImpl of super::IAggregator<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {

            let caller = get_caller_address();

            // check if the caller has access
            self.__has_access();

            assert(amount > 0, 'Amount cannot be 0');
            let counter = ICounterDispatcher { contract_address: self.counter.read() };

            let counter_count = counter.get_count();
            self.count.write(counter_count + amount);

            self
                .emit(
                    Event::increased_aggregator_count(
                        increased_aggregator_count {
                            amount: amount, 
                            caller_address: caller,
                        },
                    ),
                );
        }

        fn increase_counter_count(ref self: ContractState, amount: u32) {
            let killswitch: IKillSwitchDispatcher = IKillSwitchDispatcher {
                contract_address: self.killswitch.read(),
            };

            self.__has_access();

            let caller = get_caller_address();

            assert(killswitch.get_status(), 'not active');
            ICounterDispatcher { contract_address: self.counter.read() }.increase_count(amount);

            self
                .emit(
                    Event::increased_aggregator_count(
                        increased_aggregator_count {
                            amount: amount, 
                            caller_address: caller
                        },
                    ),
                );
        }

        fn decrease_count_by_one(ref self: ContractState) {
            self.__has_access();

            let caller = get_caller_address();

            let current_count = self.get_count();
            assert!(current_count != 0, "Amount cannot be 0");
            self.count.write(current_count - 1);

            self
                .emit(
                    Event::decreased_aggregator_count(
                        decreased_aggregator_count {
                            amount: 1, caller_address: caller,
                        },
                    ),
                );
        }

        fn activate_switch(ref self: ContractState) {
            self.__has_access();

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
    impl internalImpl of InternalTrait {
        fn __has_access(self: @ContractState) {
            let caller = get_caller_address();

            let owner = IOwnableDispatcher { contract_address: self.ownable_address.read() }
                .get_owner();

            assert(caller == owner, 'Only owner can increase count');
        }

        fn __validator(
            self: @ContractState,
            counter: ContractAddress,
            killswitch: ContractAddress,
            ownable_address: ContractAddress,
        ) {
            // Check if addresses are not reused
            assert(counter != killswitch && counter != ownable_address, 'counter address reused');

            assert(
                killswitch != ownable_address && killswitch != counter, 'killswitch address reused',
            );

            assert(
                ownable_address != killswitch && ownable_address != counter,
                'ownable address reused',
            )
        }
    }
}
