#[starknet::interface]
pub trait IOwner<TContractState> {
    fn get_owner(self: @TContractState) -> starknet::ContractAddress;


    fn transfer_owner(ref self: TContractState, new_owner: starknet::ContractAddress);
}
