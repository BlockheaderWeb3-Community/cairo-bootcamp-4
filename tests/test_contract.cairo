use cohort_4::counter::{
    ICounterDispatcher, ICounterDispatcherTrait, ICounterSafeDispatcher,
    ICounterSafeDispatcherTrait,
};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::ContractAddress;

fn deploy_contract() -> ContractAddress {
    let countract_name: ByteArray = "Counter";
    let contract = declare(countract_name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_increase_count() {
    let contract_address = deploy_contract();

    let dispatcher = ICounterDispatcher { contract_address };

    let balance_before = dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    dispatcher.increase_count(42);

    let balance_after = dispatcher.get_count();
    assert(balance_after == 42, 'Invalid balance');
}

#[test]
#[feature("safe_dispatcher")]
fn test_cannot_increase_balance_with_zero_value() {
    let contract_address = deploy_contract();

    let dispatcher = ICounterDispatcher { contract_address };

    let balance_before = dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    let safe_dispatcher = ICounterSafeDispatcher { contract_address };

    match safe_dispatcher.increase_count(0) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
        },
    };
}
