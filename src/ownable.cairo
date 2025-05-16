#[starknet::contract]
pub mod Ownable {
    use starknet::event::EventEmitter;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, contract_address_const, get_caller_address};
    use crate::interfaces::Iowner::IOwner;


    #[storage]
    struct Storage {
        pub owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnershipTransferred: OwnershipTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        previous_owner: ContractAddress,
        new_owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        let address_zero = contract_address_const::<0>();
        assert(initial_owner != address_zero, 'Owner cannot be zero');
        self.owner.write(initial_owner);
    }


    #[abi(embed_v0)]
    impl Owner of IOwner<ContractState> {
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }


        fn transfer_owner(ref self: ContractState, new_owner: ContractAddress) {
            self.check_for_owner();
            let address_zero = contract_address_const::<0>();
            assert(new_owner != address_zero, 'new owner cannot be  zero');

            let previous_owner = self.owner.read();
            self.owner.write(new_owner)
        }
    }


    //private function

    #[generate_trait]
    impl Internalownable of InternalownableTrait {
        fn check_for_owner(self: @ContractState) {
            let caller = get_caller_address();

            let owner = self.owner.read();
            assert(caller == owner, 'you are not the owner');
        }
    }
}
