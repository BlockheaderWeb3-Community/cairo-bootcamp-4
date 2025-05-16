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
