#[starknet::interface]
pub trait ICounter<TContractState> {
    /// Increase contract count.
    fn increase_count(ref self: TContractState, amount: u32);

    /// Decrease contract count by one
    fn decrease_count_by_one(ref self: TContractState);

    /// Retrieve contract count.
    fn get_count(self: @TContractState) -> u32;
}
