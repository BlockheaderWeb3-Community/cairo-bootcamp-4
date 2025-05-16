use cohort_4::killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait, KillSwitch};
use cohort_4::killswitch::KillSwitch::{EventSwitched};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare, spy_events, EventSpyAssertionsTrait};
use starknet::ContractAddress;

fn deploy()-> (IKillSwitchDispatcher, ContractAddress){
    let contract = declare("KillSwitch").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let killswitch = IKillSwitchDispatcher{contract_address};

    (killswitch, contract_address)
}

#[test]
fn test_get_status(){
    let (killswitch, _)= deploy();

    let current_status = killswitch.get_status();
 
    assert(!current_status, 'status is not valid');
}

#[test]
fn test_switch(){
    let (killswitch, _) = deploy();
     
     let prev_status = killswitch.get_status();
     killswitch.switch();

     assert(!prev_status, 'Status did not change');
}

#[test]
fn test_switch_event(){
    let (killswitch, contract_address) = deploy();

    
    let mut spy = spy_events();

    killswitch.switch();

    
    spy.assert_emitted(@array![(contract_address,
        KillSwitch::Event::EventSwitched( EventSwitched{ status: true}),
    ),])
}