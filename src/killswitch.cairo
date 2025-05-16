/// Simple contract for managing count.
#[starknet::contract]
mod KillSwitch {
    use cohort_4::interfaces::Ikillswitch::IKillSwitch;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        status: bool,
    }


    #[abi(embed_v0)]
    impl KillSwitchImpl of IKillSwitch<ContractState> {
        fn switch(ref self: ContractState) {
            // assert(amount != 0, 'Amount cannot be 0');
            self.status.write(!self.status.read());
        }


        fn get_status(self: @ContractState) -> bool {
            self.status.read()
        }
    }
}
