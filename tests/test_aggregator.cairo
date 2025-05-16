use cohort_4::aggregator::{IAggregatorDispatcher, IAggregatorDispatcherTrait, IAggregatorSafeDispatcher, Agggregator};
use cohort_4::IOwnable::{IOwnableDispatcher, IOwnableDispatcherTrait, IOwnableSafeDispatcher};
use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
use cohort_4::counter::{ICounterDispatcher,ICounterDispatcherTrait};
use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address, spy_events, EventSpyAssertionsTrait};

use cohort_4::aggregator::Agggregator::{increased_aggregator_count, Event};



fn deploy_ownable_contract(initial_address: ContractAddress) ->  (IOwnableDispatcher, ContractAddress, ) {
    let contract = declare("Ownable").unwrap().contract_class();

    // serialize call_data
    let mut calldata: Array<felt252> = array![];
    initial_address.serialize(ref calldata);

    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    let ownable = IOwnableDispatcher{contract_address};
    let safe_owner = IOwnableSafeDispatcher{contract_address};

    return (ownable, contract_address);
}

fn deploy_counter_contract() -> (ICounterDispatcher, ContractAddress) {
    let countract_name: ByteArray = "Counter";
    let contract = declare(countract_name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    let counter = ICounterDispatcher{contract_address};
    return (counter, contract_address);
}

fn deploy_killswitch_contract()-> (IKillSwitchDispatcher, ContractAddress){
    let contract = declare("KillSwitch").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let killswitch = IKillSwitchDispatcher{contract_address};

    return (killswitch, contract_address);
}

// deploy aggregator
fn deploy_aggregator() -> (IAggregatorDispatcher, IAggregatorSafeDispatcher, ContractAddress, ContractAddress) {
   
    let (ownable, ownable_address) = deploy_ownable_contract(OWNER());
    let owner_address = ownable.get_owner();  // Get the actual owner address
    
    let (_, counter_address) = deploy_counter_contract();
    let (_, killswitch_address) = deploy_killswitch_contract();

    let contract = declare("Agggregator").unwrap().contract_class();

    // serialize call data
    let mut calldata: Array<felt252> = array![];
    counter_address.serialize(ref calldata);
    killswitch_address.serialize(ref calldata); 
    ownable_address.serialize(ref calldata);  // Use the actual ownable contract address

    let(contract_address, _) = contract.deploy(@calldata).unwrap();
    let aggregator = IAggregatorDispatcher{contract_address};
    let safe_aggregator = IAggregatorSafeDispatcher{contract_address};

    return (aggregator, safe_aggregator, contract_address, owner_address);
}

fn OWNER() -> ContractAddress{
    'OWNER'.try_into().unwrap()
}

// fn ADDRESS_2() -> ContractAddress {
//     let owner_address: ContractAddress = 'OWNER_1'.try_into().unwrap();
//     owner_address
// }

// fn ADDRESS_3() -> ContractAddress {
//     let owner_address: ContractAddress = 'OWNER_2'.try_into().unwrap();
//     owner_address
// }

#[test]
fn test_get_count(){
    let (aggregator, _, _, _) = deploy_aggregator();

    let aggregator_current_count = aggregator.get_count();
    assert(aggregator_current_count == 0, 'Aggregator count should be zero');
}

#[test]
fn test_aggregator_increase_count() {
    // Get all values from the single deployment
    let (aggregator, _, aggregator_address, owner_address) = deploy_aggregator();
    
    let aggregator_count_1 = aggregator.get_count();
    assert(aggregator_count_1 == 0, 'Aggregator count should be zero');
    
    // Use the owner address to make the call
    start_cheat_caller_address(aggregator_address, owner_address);
    
    aggregator.increase_count(20);
    
    let aggregator_count_2 = aggregator.get_count();
    assert(aggregator_count_2 == 20, 'Aggregator count invalid');
}

// #[test]
// #[feature("safe_dispatcher")]
// fn test_aggregator_increase_count_by_zero(){
//     let (aggregator, safe_aggregator, aggregator_address, owner_address) = deploy_aggregator();

//     let aggregator_count_1 = aggregator.get_count();
//     assert(aggregator_count_1== 0, 'Aggregator count should be zero');

//      // impersonate owner 
//      start_cheat_caller_address(aggregator_address, owner_address);
    
//      match safe_aggregator.increase_count(0){
//         Result::Ok(_) => panic!("increasing by zero should panic"),
//         Result::Err(panic_data) => assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0))
//     }
// } 

// #[test]
// fn test_aggregator_increase_count_event(){
    
//     let (aggregator, _, aggregator_address, owner_address) = deploy_aggregator();
//     let mut spy = spy_events();

//     let aggregator_count_1 = aggregator.get_count();
//     assert(aggregator_count_1 == 0, 'Aggregator count should be zero');
    
//     // Use the owner address to make the call
//     start_cheat_caller_address(aggregator_address, owner_address);
    
//     aggregator.increase_count(20);

    
//     spy.assert_emitted(@array![(owner_address,
//         Event::increased_aggregator_count(increased_aggregator_count{ amount: 20, caller_address: owner_address}),
//     ),])
// }