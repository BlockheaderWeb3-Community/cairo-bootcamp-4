use super::*;

#[test]
fn test_use_switch() {
    let (_, killswitch_dispatcher, _, _) = deploy_contract();
    // check kill status_
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'switch status failed');

    killswitch_dispatcher.switch();
    let status_after = killswitch_dispatcher.get_status();
    assert(status_after, 'nothing changed');

}

#[test]
fn test_get_switch_status() {
    let (_, killswitch_dispatcher, _, _) = deploy_contract();
    //check kill switch status
    let status = killswitch_dispatcher.get_status();
    assert(!status, 'switch status failed');
}