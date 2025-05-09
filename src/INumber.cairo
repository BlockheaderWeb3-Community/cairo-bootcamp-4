/// A trait for a contract that can store and retrieve a number
#[starknet::interface]
pub trait INumber<TContractState> {
    /// Sets the number to the given value
    fn set_number(ref self: TContractState, amount: u8);
    /// Returns the current number
    fn get_number(self: @TContractState) -> u8;
}
