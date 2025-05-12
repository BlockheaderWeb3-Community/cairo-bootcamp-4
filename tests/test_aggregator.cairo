
use super::*;



#[test]
fn test_initial_count_balance_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();
    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    //check balance to ensure it is zero
    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'wrong intial count');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}


#[test]
fn test_increase_count_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();
    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    let balance_1 = aggregator_dispatcher.get_count();
    assert(balance_1 == 0, 'wrong starting balance');
    //increase count
    aggregator_dispatcher.increase_count(42);

    let balance_after = aggregator_dispatcher.get_count();
    //check balance to be sure increase occured
    assert(balance_after == 42, 'wrong new balance');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}

#[test]
fn test_increase_counter_count_aggregator() {
    let (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();

    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    let count_1 = aggregator_dispatcher.get_count();
    assert(count_1 == 0, 'invalid count 1');

    //check if killswitch is off
    let status_before = killswitch_dispatcher.get_status();
    assert(!status_before, 'incorrect killswitch status');
    //turn on the switch
    aggregator_dispatcher.activate_switch();
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'failed to activate');
    //increase the counter count
    aggregator_dispatcher.increase_counter_count(42);

    //check if the count increased
    let count_2 = counter_dispatcher.get_count();
    assert(count_2 == 42, 'invalid count_2');
}


#[test]
fn test_decrease_count_by_one_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'intial count is not zero');

    aggregator_dispatcher.increase_count(58);
    aggregator_dispatcher.decrease_count_by_one();

    let count_after = aggregator_dispatcher.get_count();
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
    assert(count_after == 57, 'count is incorrect');
}

#[test]
fn test_activate_switch_aggregator() {
    let (_, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();
    // check kill status_
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'switch status failed');

    // Start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    // Activate the switch
    aggregator_dispatcher.activate_switch();
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
    //check status once more
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'switch status not active');
}


#[test]
#[should_panic(expect: 'Caller is not owner')]
fn test_should_panic_initial_count_balance_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();
    //start prank as non-owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, NON_OWNER());
    //check balance to ensure it is zero
    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'wrong intial count');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}

#[test]
#[should_panic(expect: 'Amount cannot be 0')]
fn test_increase_count_aggregator_by_zero() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();
    //start prank as non-owner 
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());

    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'wrong intial count');
    aggregator_dispatcher.increase_count(0);
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}

#[test]
#[should_panic(expect: 'Caller is not owner')]
fn test_should_panic_increase_count_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();
    //start prank as non-owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, NON_OWNER());
    let balance_1 = aggregator_dispatcher.get_count();
    assert(balance_1 == 0, 'wrong starting balance');
    //increase count
    aggregator_dispatcher.increase_count(42);

    let balance_after = aggregator_dispatcher.get_count();
    //check balance to be sure increase occured
    assert(balance_after == 42, 'wrong new balance');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}


#[test]
#[should_panic(expect: 'Caller is not owner')]
fn test_should_panic_increase_counter_count_aggregator() {
    let (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();

    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, NON_OWNER());
    let count_1 = aggregator_dispatcher.get_count();
    assert(count_1 == 0, 'invalid count 1');

    //check if killswitch is off
    let status_before = killswitch_dispatcher.get_status();
    assert(!status_before, 'incorrect killswitch status');
    //turn on the switch
    aggregator_dispatcher.activate_switch();
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'failed to activate');
    //increase the counter count
    aggregator_dispatcher.increase_counter_count(42);

    //check if the count increased
    let count_2 = counter_dispatcher.get_count();
    assert(count_2 == 42, 'invalid count_2');
}


#[test]
#[should_panic(expect: 'Caller is not owner')]
fn test_should_panic_decrease_count_by_one_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, NON_OWNER());
    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'intial count is not zero');

    aggregator_dispatcher.increase_count(58);
    aggregator_dispatcher.decrease_count_by_one();

    let count_after = aggregator_dispatcher.get_count();
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
    assert(count_after == 57, 'count is incorrect');
}

#[test]
#[should_panic(expect: 'Caller is not owner')]
fn test_should_panic_activate_switch_aggregator() {
    let (_, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();
    // check kill status_
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'switch status failed');

    // Start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, NON_OWNER());
    // Activate the switch
    aggregator_dispatcher.activate_switch();
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
    //check status once more
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'switch status not active');
}

// Tests to check for events!

#[test]
fn test_should_emit_increase_count_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();

    let mut spy = spy_events();

    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());

    let balance_1 = aggregator_dispatcher.get_count();
    assert(balance_1 == 0, 'wrong starting balance');

    //increase count
    aggregator_dispatcher.increase_count(42);

    let balance_after = aggregator_dispatcher.get_count();
    //check balance to be sure increase occured
    assert(balance_after == 42, 'wrong new balance');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);

    let expected_event = Event::CountIncreased(
        CountIncreased { new_count: balance_after, caller: OWNER() },
    );

    // Assert the event was emitted
    spy.assert_emitted(@array![(aggregator_dispatcher.contract_address, expected_event)]);
}

#[test]
fn test_should_emit_increase_counter_count_aggregator() {
    let (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();

    let mut spy = spy_events();

    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    let count_1 = aggregator_dispatcher.get_count();
    assert(count_1 == 0, 'invalid count 1');

    //check if killswitch is off
    let status_before = killswitch_dispatcher.get_status();
    assert(!status_before, 'incorrect killswitch status');
    //turn on the switch
    aggregator_dispatcher.activate_switch();
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'failed to activate');
    //increase the counter count
    aggregator_dispatcher.increase_counter_count(42);

    //check if the count increased
    let count_2 = counter_dispatcher.get_count();
    assert(count_2 == 42, 'invalid count_2');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);

    let expected_event = Event::CounterCountIncreased(
        CounterCountIncreased { new_counter: count_2, caller: OWNER() },
    );

    //Check if the event was emmitted
    spy.assert_emitted(@array![(aggregator_dispatcher.contract_address, expected_event)]);
}

#[test]
fn test_should_emit_decrease_count_by_one_aggregator() {
    let (_, _, aggregator_dispatcher, _) = deploy_contract();

    let mut spy = spy_events();
    //start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'intial count is not zero');
    //increase count to have value > 0 to decrease from
    aggregator_dispatcher.increase_count(58);
    aggregator_dispatcher.decrease_count_by_one();
    //check new count value
    let count_after = aggregator_dispatcher.get_count();
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
    //assert that you have the right count value
    assert(count_after == 57, 'count is incorrect');
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);

    let expected_event = Event::CountDecreasedByOne(
        CountDecreasedByOne { new_count: count_after, caller: OWNER() },
    );
    //check that event was emitted
    spy.assert_emitted(@array![(aggregator_dispatcher.contract_address, expected_event)]);
}

#[test]
fn test_should_emit_activate_switch_aggregator() {
    let (_, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();

    let mut spy = spy_events();

    // check kill status
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'switch status failed');

    // Start prank as owner
    start_cheat_caller_address(aggregator_dispatcher.contract_address, OWNER());
    // Activate the switch
    aggregator_dispatcher.activate_switch();
    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
    //check status once more
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'switch status not active');

    let expected_event = Event::SwitchStatus(SwitchStatus { status: status_after, caller: OWNER()});

    //check that event was emitted
    spy.assert_emitted(@array![(aggregator_dispatcher.contract_address, expected_event)]);

}


// #[test]
// #[feature("safe_dispatcher")]
// fn test_fail_for_non_owner_increase_counter_count() {
//     let (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher, _) = deploy_contract();

//     //start prank as non-owner
//     start_cheat_caller_address(aggregator_dispatcher.contract_address, NON_OWNER());
//     let count_1 = aggregator_dispatcher.get_count();
//     assert(count_1 == 0, 'invalid count 1');

//     //check if killswitch is off
//     let status_before = killswitch_dispatcher.get_status();
//     assert(!status_before, 'incorrect killswitch status');
//     //turn on the switch
//     aggregator_dispatcher.activate_switch();
//     let status_after = killswitch_dispatcher.get_status();
//     assert(status_after, 'failed to activate');
//     //increase the counter count
//     aggregator_dispatcher.increase_counter_count(42);

//     //check if the count increased
//     let count_2 = counter_dispatcher.get_count();
//     assert(count_2 == 42, 'invalid count_2');

//     let safe_dispatcher = IAggregatorSafeDispatcher {
//         contract_address: NON_OWNER(),
//     };

//     match safe_dispatcher.increase_counter_count(2) {
//         Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Caller is not owner', *panic_data.at(0));
//         },
//     };

// }
