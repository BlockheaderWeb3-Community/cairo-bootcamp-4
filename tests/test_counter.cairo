use cohort_4::interfaces::Icounter::{
    ICounterDispatcher, ICounterDispatcherTrait, ICounterSafeDispatcher,
    ICounterSafeDispatcherTrait,
};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::ContractAddress;


fn deploy() -> (ICounterDispatcher, ICounterSafeDispatcher, ContractAddress) {
    let counter_countract_name: ByteArray = "Counter";
    let contract = declare(counter_countract_name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    let counter = ICounterDispatcher { contract_address };
    let safe_counter = ICounterSafeDispatcher { contract_address };
    return (counter, safe_counter, contract_address);
}


#[test]
fn test_initialized_count() {
    let (counter, _, _) = deploy();
    let count_1 = counter.get_count();
    assert(count_1 == 0, 'invalid count value');
}

#[test]
fn test_increase_count() {
    let (counter, _, _) = deploy();
    let count_1 = counter.get_count();
    assert(count_1 == 0, 'invalid count value');

    let amount = 30;
    counter.increase_count(amount);
    let count_2 = counter.get_count();
    assert(count_2 == amount, 'Invalid amount');
    assert(count_2 != 10, 'invalid 10')
}

#[test]
#[feature("safe_dispatcher")]
fn test_increase_count_by_zero_amount() {
    let (counter, safe_counter, _) = deploy();

    let count_1 = counter.get_count();
    assert(count_1 == 0, 'invalid count value');

    match safe_counter.increase_count(0) {
        Result::Ok(_) => panic!("amount passed not zero"),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0))
        },
    }
}


#[test]
fn test_for_decrease_count_by_one() {
    let (counter, _, _) = deploy();

    let count_1 = counter.get_count();
    assert(count_1 == 0, 'Invalid count value not zero');

    counter.increase_count(2);

    counter.decrease_count_by_one();
    let count_2 = counter.get_count();
    assert(count_1 == count_2 - 1, 'Invalid count value');
}

