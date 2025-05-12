/// Interface representing `Counter`.
/// This interface allows modification and retrieval of the contract count.
#[starknet::interface]
pub trait ICounter<TContractState> {
    /// Increase contract count.
    fn increase_count(ref self: TContractState, amount: u32);

    /// Decrease contract count by one
    fn decrease_count_by_one(ref self: TContractState);

    /// Retrieve contract count.
    fn get_count(self: @TContractState) -> u32;
}

/// Simple contract for managing count.
#[starknet::contract]
mod Counter {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        count: u32,
    }

    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            assert(amount > 0, 'Amount cannot be 0');
            let counter_count = self.get_count();
            self.count.write(counter_count + amount);
        }

        fn decrease_count_by_one(ref self: ContractState) {
            let current_count = self.get_count();
            assert(current_count > 0, 'Amount cannot be 0');
            self.count.write(current_count - 1);
        }

        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
    }
}
