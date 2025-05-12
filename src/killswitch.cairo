/// Interface representing `HelloContract`.
/// This interface allows modification and retrieval of the contract count.
#[starknet::interface]
pub trait IKillSwitch<TContractState> {
    /// Increase contract count.
    fn switch(ref self: TContractState);

    /// Retrieve contract count.
    fn get_status(self: @TContractState) -> bool;
}

/// Simple contract for managing count.
#[starknet::contract]
mod KillSwitch {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        status: bool,
    }


    #[abi(embed_v0)]
    impl KillSwitchImpl of super::IKillSwitch<ContractState> {
        fn switch(ref self: ContractState) {
            self.status.write(!self.status.read());
        }


        fn get_status(self: @ContractState) -> bool {
            self.status.read()
        }
    }
}
