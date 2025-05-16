use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnable<TContractState> {
    fn set_owner(ref self: TContractState, new_owner: ContractAddress);

    fn get_owner(self: @TContractState) -> ContractAddress;
}
