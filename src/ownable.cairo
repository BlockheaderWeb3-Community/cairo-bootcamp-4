use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnable<TContractState> {
    fn set_owner(ref self: TContractState, owner: ContractAddress);
    fn get_owner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod Ownable {
    use core::num::traits::Zero;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address};

    
    #[storage]
    struct Storage {
        owner: ContractAddress,
    }
    

    #[constructor]
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        assert(initial_owner.is_non_zero(), 'Owner cannot be zero address');
        self.owner.write(initial_owner);
    }

    #[abi(embed_v0)]
    impl OwnableImpl of super::IOwnable<ContractState> {
        fn set_owner(ref self: ContractState, owner: ContractAddress) {
            let caller = get_caller_address();
            let current_owner = self.owner.read();
            assert(current_owner == caller, 'Nope! only owner can call this');
            assert(owner.is_non_zero(), 'New owner cant be zero address');
            //Set the owner
            self.owner.write(owner);
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}
