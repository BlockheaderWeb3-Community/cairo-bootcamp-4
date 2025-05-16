use cohort_4::IOwnable::IOwnableSafeDispatcherTrait;
use cohort_4::IOwnable::{IOwnableDispatcher, IOwnableDispatcherTrait, IOwnableSafeDispatcher};
use snforge_std::{
    ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
    stop_cheat_caller_address,
};
use starknet::ContractAddress;
// create deploy utils function
fn deploy(initial_address: ContractAddress) -> (IOwnableDispatcher, IOwnableSafeDispatcher, ContractAddress, ContractAddress) {
    // let owner_address: ContractAddress = 'ownable'.try_into().unwrap();

    let contract = declare("Ownable").unwrap().contract_class();

    // serialize call_data
    let mut calldata: Array<felt252> = array![];
    initial_address.serialize(ref calldata);

    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    let owner = IOwnableDispatcher { contract_address};
    let safe_owner  = IOwnableSafeDispatcher{contract_address};

    return (owner, safe_owner, initial_address, contract_address);
}

fn OWNER() -> ContractAddress{
    'OWNER'.try_into().unwrap()
}

fn OWNER_1() -> ContractAddress {
    let owner_address: ContractAddress = 'OWNER_1'.try_into().unwrap();
    owner_address
}

fn OWNER_2() -> ContractAddress {
    let owner_address: ContractAddress = 'OWNER_2'.try_into().unwrap();
    owner_address
}

#[test]
fn test_ownable_get_owner() {
    let (owner, _, owner_address, _) = deploy(OWNER());

    let current_owner = owner.get_owner();
    assert(owner_address == current_owner, 'got wrong owner address');
}

#[test]
fn test_ownable_set_owner(){
    let (owner, _,owner_address,ownable_address) = deploy(OWNER());

    start_cheat_caller_address(ownable_address, owner_address);

    owner.set_owner(OWNER_2());

    let updated_owner = owner.get_owner();

    assert(OWNER_2() == updated_owner, 'Did not update owner');

}

#[test]
#[feature("safe_dispatcher")]
fn test_set_owner_to_previous_owner(){
    let (_,safe_owner, _, _) = deploy(OWNER());

    match safe_owner.set_owner(OWNER()){
        Result::Ok(_) => panic!("setting same owner should panic"),
        Result::Err(panic_data) => assert(*panic_data.at(0) == 'Only owner can set new owner', *panic_data.at(0))
    }
} 
