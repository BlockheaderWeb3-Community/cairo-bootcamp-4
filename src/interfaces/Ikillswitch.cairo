/// Interface representing `HelloContract`.
/// This interface allows modification and retrieval of the contract count.
#[starknet::interface]
pub trait IKillSwitch<TContractState> {
    /// Increase contract count.
    fn switch(ref self: TContractState);

    /// Retrieve contract count.
    fn get_status(self: @TContractState) -> bool;
}
