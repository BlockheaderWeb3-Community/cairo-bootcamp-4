/// Simple contract for managing count.
#[starknet::contract]
pub mod Counter {
    use cohort_4::interfaces::Icounter::ICounter;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        count: u32,
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        IncreaseCount: IncreaseCount,
        DecreaseCount: DecreaseCount,
    }

    #[derive(Drop, starknet::Event)]
    pub struct IncreaseCount {
        pub count: u32,
    }

    #[derive(Drop, starknet::Event)]
    pub struct DecreaseCount {
        pub count: u32,
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            assert(amount > 0, 'Amount cannot be 0');
            let counter_count = self.get_count();

            let new_count = counter_count + amount;
            self.count.write(counter_count + amount);
            self.emit(Event::IncreaseCount(IncreaseCount { count: new_count }));
        }

        fn decrease_count_by_one(ref self: ContractState) {
            let current_count = self.get_count();
            assert(current_count > 0, 'Amount cannot be 0');
            let new_count = current_count - 1;
            self.count.write(new_count);
            self.emit(Event::DecreaseCount(DecreaseCount { count: new_count }));
        }

        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
    }
}
