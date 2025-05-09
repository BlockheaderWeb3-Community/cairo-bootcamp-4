use cohort_4::aggregator::{IAggregatorDispatcher, IAggregatorDispatcherTrait};
use cohort_4::counter::{
    ICounterDispatcher, ICounterDispatcherTrait, ICounterSafeDispatcher,
    ICounterSafeDispatcherTrait,
};
use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};


fn deploy_contract() -> (ICounterDispatcher, IKillSwitchDispatcher, IAggregatorDispatcher) {
    //counter deployment
    let counter_countract_name: ByteArray = "Counter";
    let contract = declare(counter_countract_name).unwrap().contract_class();
    let (counter_contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    let counter_dispatcher = ICounterDispatcher { contract_address: counter_contract_address };

    //killswitch deployment
    let killswitch_contract_name: ByteArray = "KillSwitch";
    let killswitch_contract = declare(killswitch_contract_name).unwrap().contract_class();
    let (killswitch_contract_address, _) = killswitch_contract.deploy(@ArrayTrait::new()).unwrap();
    let killswitch_dispatcher = IKillSwitchDispatcher {
        contract_address: killswitch_contract_address,
    };

    //aggregator deployment
    let aggregator = declare("Agggregator").unwrap().contract_class();
    let (aggregator_contract_address, _) = aggregator
        .deploy(@array![counter_contract_address.into(), killswitch_contract_address.into()])
        .unwrap();

    let aggregator_dispatcher = IAggregatorDispatcher {
        contract_address: aggregator_contract_address,
    };

    (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher)
}

#[test]
fn test_increase_count() {
    let (counter_dispatcher, _, _) = deploy_contract();

    let balance_before = counter_dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    counter_dispatcher.increase_count(42);

    let balance_after = counter_dispatcher.get_count();
    assert(balance_after == 42, 'Invalid balance');
}

#[test]
#[feature("safe_dispatcher")]
fn test_cannot_increase_balance_with_zero_value() {
    let (counter_dispatcher, _, _) = deploy_contract();

    let balance_before = counter_dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    let safe_dispatcher = ICounterSafeDispatcher {
        contract_address: counter_dispatcher.contract_address,
    };

    match safe_dispatcher.increase_count(0) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
        },
    };
}

#[test]
fn test_increase_count_aggregator() {
    let (_, _, aggregator_dispatcher) = deploy_contract();

    let balance_before = aggregator_dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    aggregator_dispatcher.increase_count(42);

    let balance_after = aggregator_dispatcher.get_count();
    assert(balance_after == 42, 'Invalid balance');
}

#[test]
fn test_increase_counter_count_aggregator() {
    let (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher) = deploy_contract();

    let count_1 = counter_dispatcher.get_count();
    assert(count_1 == 0, 'invalid count 1');

    let status_before = killswitch_dispatcher.get_status();
    assert(!status_before, 'incorrect status');

    aggregator_dispatcher.activate_switch();
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'failed to activate');

    aggregator_dispatcher.increase_counter_count(42);

    let count_2 = counter_dispatcher.get_count();
    assert(count_2 == 42, 'invalid count 2');
}

#[test]
fn test_decrease_count_by_one_aggregator() {
    let (_, _, aggregator_dispatcher) = deploy_contract();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 0, 'invalid count');

    aggregator_dispatcher.increase_count(20);
    aggregator_dispatcher.decrease_count_by_one();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 19, 'incorrect count');
}


#[test]
fn test_increase_activate_switch() {
    let (_, killswitch_dispatcher, aggregator_dispatcher) = deploy_contract();

    let status = killswitch_dispatcher.get_status();
    assert(!status, 'failed');

    aggregator_dispatcher.activate_switch();

    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'invalid status');
}

#[test]
#[should_panic(expect: 'Amount cannot be 0')]
fn test_increase_count_by_zero_aggregator() {
    let (_, _, aggregator_dispatcher) = deploy_contract();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 0, 'incorrect count');

    aggregator_dispatcher.increase_count(0);
}

#[test]
#[should_panic(expect: 'should be active')]
fn test_increase_counter_count_error() {
    let (_, killswitch_dispatcher, aggregator_dispatcher) = deploy_contract();

    let status_before = killswitch_dispatcher.get_status();
    assert(status_before, 'invalid status');

    aggregator_dispatcher.increase_counter_count(42);
}

#[test]
#[should_panic(expect: "Amount cannot be 0")]
fn test_decrease_zero_count_by_one_aggregator() {
    let (_, _, aggregator_dispatcher) = deploy_contract();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 0, 'invalid count');

    aggregator_dispatcher.decrease_count_by_one();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 19, 'incorrect count');
}
