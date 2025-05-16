use starknet::{ContractAddress, get_caller_address};
use crate::IOwnable::IOwnable;

#[starknet::contract]
mod Ownable {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::*;


    #[storage]
    struct Storage {
        owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.__zero_checker(owner);
        self.owner.write(owner);
    }

    #[abi(embed_v0)]
    impl OwnableImpl of IOwnable<ContractState> {
        fn set_owner(ref self: ContractState, new_owner: ContractAddress) {
            let caller = get_caller_address();
            assert(self.owner.read() == caller, 'Only owner can set new owner');

            self.__zero_checker(new_owner);

          assert(
                self.owner.read() != new_owner, 'New owner not valid address',
            );
            self.owner.write(new_owner);
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }

    #[generate_trait]
    impl internalimpl of internalInterface {
        fn __zero_checker(ref self: ContractState, some_address: ContractAddress) {
            let zero_address = 'zero_address'.try_into().unwrap();
            assert(some_address != zero_address, 'Address cannot be zero');
        }
    }
}
