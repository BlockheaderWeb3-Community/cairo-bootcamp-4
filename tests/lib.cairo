use cohort_4::aggregator::Aggregator::{
    CountDecreasedByOne, CountIncreased, CounterCountIncreased, Event, SwitchStatus,
};
use cohort_4::aggregator::{IAggregatorDispatcher, IAggregatorDispatcherTrait,};
use cohort_4::counter::{
    ICounterDispatcher, ICounterDispatcherTrait, ICounterSafeDispatcher,
    ICounterSafeDispatcherTrait,
};
use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
use cohort_4::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
use core::traits::TryInto;
use core::num::traits::Zero;
use snforge_std::{
    ContractClassTrait, DeclareResultTrait, EventSpyAssertionsTrait, declare, spy_events,
    start_cheat_caller_address, stop_cheat_caller_address,
};
use starknet::ContractAddress;
pub mod test_aggregator;
pub mod test_counter;
pub mod test_killswitch;
pub mod test_ownable;

fn deploy_contract() -> (
    ICounterDispatcher, IKillSwitchDispatcher, IAggregatorDispatcher, IOwnableDispatcher,
) {
    //counter deployment
    let counter_countract_name: ByteArray = "Counter";
    let contract = declare(counter_countract_name)
        .expect('counter contract is not working')
        .contract_class();
    let (counter_contract_address, _) = contract
        .deploy(@ArrayTrait::new())
        .expect('counter address issue');
    let counter_dispatcher = ICounterDispatcher { contract_address: counter_contract_address };

    //killswitch deployment
    let killswitch_contract_name: ByteArray = "KillSwitch";
    let killswitch_contract = declare(killswitch_contract_name)
        .expect('killswitch contract not working')
        .contract_class();
    let (killswitch_contract_address, _) = killswitch_contract
        .deploy(@ArrayTrait::new())
        .expect('killswitch address issue');
    let killswitch_dispatcher = IKillSwitchDispatcher {
        contract_address: killswitch_contract_address,
    };

    //ownable deployment
    let ownable_contract_name: ByteArray = "Ownable";
    let ownable_contract = declare(ownable_contract_name)
        .expect('ownable contract not working')
        .contract_class();
    let (ownable_contract_address, _) = ownable_contract
        .deploy(@array![OWNER().into()])
        .expect('ownable address issue');
    let ownable = IOwnableDispatcher { contract_address: ownable_contract_address };

    //aggregator deployment
    let aggregator = declare("Aggregator").expect('aggregator contract error').contract_class();
    let (aggregator_contract_address, _) = aggregator
        .deploy(
            @array![
                counter_contract_address.into(),
                killswitch_contract_address.into(),
                ownable_contract_address.into(),
            ],
        )
        .expect('aggregator address issue');

    let aggregator_dispatcher = IAggregatorDispatcher {
        contract_address: aggregator_contract_address,
    };

    (counter_dispatcher, killswitch_dispatcher, aggregator_dispatcher, ownable)
}

//Test accounts
fn OWNER() -> ContractAddress {
    'OWNER'.try_into().unwrap()
}

fn NON_OWNER() -> ContractAddress {
    'NON_OWNER'.try_into().unwrap()
}

fn NEW_OWNER() -> ContractAddress {
    'NEW_OWNER'.try_into().unwrap()
}

fn zero_address() -> ContractAddress {
    Zero::zero()
}
