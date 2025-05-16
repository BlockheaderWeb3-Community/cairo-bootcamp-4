use cohort_4::interfaces::Iaggregator::{IAggregatorDispatcher, IAggregatorDispatcherTrait};
use cohort_4::interfaces::Icounter::{
    ICounterDispatcher, ICounterDispatcherTrait, ICounterSafeDispatcher,
    ICounterSafeDispatcherTrait,
};
use cohort_4::interfaces::Ikillswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
use cohort_4::interfaces::Iowner::{IOwnerDispatcher, IOwnerDispatcherTrait};
use snforge_std::{
    ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
    stop_cheat_caller_address,
};
use starknet::{ContractAddress, contract_address_const};


fn deploy_contract() -> (
    ICounterDispatcher,
    IKillSwitchDispatcher,
    IOwnerDispatcher,
    IAggregatorDispatcher,
    ContractAddress,
) {
    // owner address
    let owner_address: ContractAddress = contract_address_const::<'1'>();

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

    //ownable deployment
    let ownable_contract_name: ByteArray = "Ownable";
    let ownable_contract = declare(ownable_contract_name).unwrap().contract_class();
    // Deploy with owner_address as the initial owner
    let (ownable_contract_address, _) = ownable_contract
        .deploy(@array![owner_address.into()])
        .unwrap();
    let ownable_dispatcher = IOwnerDispatcher { contract_address: ownable_contract_address };

    //aggregator deployment
    let aggregator = declare("Agggregator").unwrap().contract_class();
    let (aggregator_contract_address, _) = aggregator
        .deploy(
            @array![
                counter_contract_address.into(),
                killswitch_contract_address.into(),
                ownable_contract_address.into(),
            ],
        )
        .unwrap();

    let aggregator_dispatcher = IAggregatorDispatcher {
        contract_address: aggregator_contract_address,
    };

    (
        counter_dispatcher,
        killswitch_dispatcher,
        ownable_dispatcher,
        aggregator_dispatcher,
        owner_address,
    )
}

#[test]
fn test_increase_count() {
    let (counter_dispatcher, _, _, _, _) = deploy_contract();

    let balance_before = counter_dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    counter_dispatcher.increase_count(42);

    let balance_after = counter_dispatcher.get_count();
    assert(balance_after == 42, 'Invalid balance');
}

#[test]
fn test_increase_count_aggregator_as_owner() {
    let (_, _, _, aggregator_dispatcher, owner_address) = deploy_contract();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, owner_address);

    let balance_before = aggregator_dispatcher.get_count();
    assert(balance_before == 0, 'Invalid balance');

    aggregator_dispatcher.increase_count(42);

    let balance_after = aggregator_dispatcher.get_count();
    assert(balance_after == 42, 'Invalid balance');

    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}

#[test]
#[should_panic(expected: ('you are not the owner',))]
fn test_increase_count_aggregator_as_non_owner() {
    let (_, _, _, aggregator_dispatcher, _) = deploy_contract();

    let non_owner_address: ContractAddress = contract_address_const::<'2'>();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, non_owner_address);

    aggregator_dispatcher.increase_count(42);

    let balance_after = aggregator_dispatcher.get_count();
    assert(balance_after == 0, 'you are not the owner');

    stop_cheat_caller_address(aggregator_dispatcher.contract_address);
}

#[test]
#[feature("safe_dispatcher")]
fn test_cannot_increase_balance_with_zero_value() {
    let (counter_dispatcher, _, _, _, _) = deploy_contract();

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
fn test_increase_counter_count() {
    let (counter_dispatcher, _, _, aggregator_dispatcher, owner_address) = deploy_contract();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, owner_address);

    let initial_count = counter_dispatcher.get_count();
    assert(initial_count == 0, 'invalid initial count');

    aggregator_dispatcher.activate_switch();

    aggregator_dispatcher.increase_counter_count(42);

    let final_count = counter_dispatcher.get_count();
    assert(final_count == 42, 'counter not increased correctly');
}

#[test]
fn test_decrease_count_by_one_aggregator() {
    let (counter_dispatcher, _, _, aggregator_dispatcher, owner_address) = deploy_contract();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, owner_address);
    let count_before = aggregator_dispatcher.get_count();
    assert(count_before == 0, 'invalid count');

    aggregator_dispatcher.increase_count(20);
    aggregator_dispatcher.decrease_count_by_one();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 19, 'incorrect count');
}

#[test]
fn test_increase_activate_switch() {
    let (_, killswitch_dispatcher, _, aggregator_dispatcher, owner_address) = deploy_contract();

    let non_owner_address: ContractAddress = contract_address_const::<'2'>();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, owner_address);
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'failed');

    aggregator_dispatcher.activate_switch();

    stop_cheat_caller_address(aggregator_dispatcher.contract_address);

    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'invalid status');
}


#[test]
#[should_panic(expect: 'you are not the owner')]
fn test_increase_activate_switch_non_owner() {
    let (_, killswitch_dispatcher, _, aggregator_dispatcher, _) = deploy_contract();

    let non_owner_address: ContractAddress = contract_address_const::<'2'>();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, non_owner_address);
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'failed');

    aggregator_dispatcher.activate_switch();

    stop_cheat_caller_address(aggregator_dispatcher.contract_address);

    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'invalid status');
}

#[test]
#[should_panic(expect: 'Amount cannot be 0')]
fn test_increase_count_by_zero() {
    let (_, killswitch_dispatcher, _, aggregator_dispatcher, _) = deploy_contract();

    let count_after = aggregator_dispatcher.get_count();
    assert(count_after == 0, 'incorrect count');

    aggregator_dispatcher.increase_count(0);
}

#[test]
#[should_panic(expect: 'should be active')]
fn test_increase_counter_count_error() {
    let (_, killswitch_dispatcher, _, aggregator_dispatcher, _) = deploy_contract();

    let non_owner_address: ContractAddress = contract_address_const::<'2'>();

    start_cheat_caller_address(aggregator_dispatcher.contract_address, non_owner_address);

    let status_before = killswitch_dispatcher.get_status();
    assert(status_before, 'invalid status');

    aggregator_dispatcher.increase_counter_count(42);
}
