
use super::*;



#[test]
fn test_check_ownable() {
    let (_, _, _, ownable) = deploy_contract();

    start_cheat_caller_address(ownable.contract_address, OWNER());
    assert(ownable.get_owner() == OWNER(), 'Oops! not the owner');
}


#[test]
fn test_check_ownable_set_new_owner() {
    let (_, _, _, ownable) = deploy_contract();

    start_cheat_caller_address(ownable.contract_address, OWNER());
    assert(ownable.get_owner() == OWNER(), 'Oops! not the owner');
    // stop_cheat_caller_address(ownable.contract_address);

    // start_cheat_caller_address(ownable.contract_address, OWNER());
    ownable.set_owner(NEW_OWNER());
    assert(ownable.get_owner() == NEW_OWNER(), 'Oops! not the new owner');
    stop_cheat_caller_address(ownable.contract_address);
}

//CHECK THIS TEST WELL
#[test]
#[should_panic(expect: 'Nope! only owner can call this')]
fn test_ownable_should_panic_with_non_owner() {
    let (_, _, _, ownable) = deploy_contract();

    //start prank as non-owner
    start_cheat_caller_address(ownable.contract_address, NON_OWNER());
    assert(ownable.get_owner() == NON_OWNER(), 'Oops! not the new owner');
    stop_cheat_caller_address(ownable.contract_address);
}
#[test]
#[should_panic(expect: 'New owner cant be zero address')]
fn test_ownable_should_panic_with_new_owner_zero_address() {
    let (_, _, _, ownable) = deploy_contract();


    start_cheat_caller_address(ownable.contract_address, OWNER());
    ownable.set_owner(zero_address());
    assert(ownable.get_owner() == zero_address(), 'Oops! not the new owner');
    stop_cheat_caller_address(ownable.contract_address);
}
