use cohort_4::{ISimpleBankDispatcher, ISimpleBankDispatcherTrait};
use snforge_std::{
    ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
    stop_cheat_caller_address,
};
use starknet::ContractAddress;

fn setup() -> ContractAddress {
    let contract_class = declare("SimpleBank").unwrap().contract_class();

    let (contract_address, _) = contract_class.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_simple_bank() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Darren";
    let address: ContractAddress = 'Darren'.try_into().unwrap();

    start_cheat_caller_address(contract_address, address);

    contract_instance.open_account(name);
    assert!(contract_instance.get_balance() == 0, "Account Creation Failed");

    contract_instance.deposit(1000);
    assert!(contract_instance.get_balance() == 1000, "Deposit Failed");

    contract_instance.withdraw(150);
    assert!(contract_instance.get_balance() == 850, "Withdrawal Failed");

    stop_cheat_caller_address(contract_address);

    let other_name: ByteArray = "Derrick";
    let other_address: ContractAddress = 'Derrick'.try_into().unwrap();

    start_cheat_caller_address(contract_address, other_address);

    contract_instance.open_account(other_name);
    assert!(contract_instance.get_balance() == 0, "Account Creation Failed");

    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, address);
    contract_instance.transfer(120, other_address);
    assert!(contract_instance.get_balance() == 730, "Transfer Failed");
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, other_address);
    assert!(contract_instance.get_balance() == 120, "Transfer Receiving Failed");
    stop_cheat_caller_address(contract_address);
}

// Test for account closure with zero balance
#[test]
fn test_close_account_zero_balance() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Alice";
    let address: ContractAddress = 'Alice'.try_into().unwrap();

    let recipient_name: ByteArray = "Bob";
    let recipient_address: ContractAddress = 'Bob'.try_into().unwrap();

    // Create Alice's account
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    assert!(contract_instance.get_balance() == 0, "Account Creation Failed");
    stop_cheat_caller_address(contract_address);

    // Create Bob's account
    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    assert!(contract_instance.get_balance() == 0, "Recipient Account Creation Failed");
    stop_cheat_caller_address(contract_address);

    // Close Alice's account with zero balance
    start_cheat_caller_address(contract_address, address);
    contract_instance.close_account(recipient_address);
    stop_cheat_caller_address(contract_address);

    // Verify Bob's balance remains unchanged
    start_cheat_caller_address(contract_address, recipient_address);
    assert!(contract_instance.get_balance() == 0, "Recipient Balance Should Remain Zero");
    stop_cheat_caller_address(contract_address);
}

// Test for account closure with positive balance
#[test]
fn test_close_account_with_balance() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Charlie";
    let address: ContractAddress = 'Charlie'.try_into().unwrap();

    let recipient_name: ByteArray = "Dave";
    let recipient_address: ContractAddress = 'Dave'.try_into().unwrap();

    // Create Charlie's account and deposit funds
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    contract_instance.deposit(500);
    assert!(contract_instance.get_balance() == 500, "Deposit Failed");
    stop_cheat_caller_address(contract_address);

    // Create Dave's account
    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    assert!(contract_instance.get_balance() == 0, "Recipient Account Creation Failed");
    stop_cheat_caller_address(contract_address);

    // Close Charlie's account with positive balance
    start_cheat_caller_address(contract_address, address);
    contract_instance.close_account(recipient_address);
    stop_cheat_caller_address(contract_address);

    // Verify Dave received Charlie's balance
    start_cheat_caller_address(contract_address, recipient_address);
    assert!(contract_instance.get_balance() == 500, "Recipient Should Receive Balance");
    stop_cheat_caller_address(contract_address);
}

// Test operations on closed account
#[test]
#[should_panic(expected: ('Account is closed',))]
fn test_deposit_to_closed_account() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Eva";
    let address: ContractAddress = 'Eva'.try_into().unwrap();

    let recipient_name: ByteArray = "Frank";
    let recipient_address: ContractAddress = 'Frank'.try_into().unwrap();

    // Create accounts
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    stop_cheat_caller_address(contract_address);

    // Close Eva's account
    start_cheat_caller_address(contract_address, address);
    contract_instance.close_account(recipient_address);

    // Try to deposit to closed account - should panic
    contract_instance.deposit(100);
    stop_cheat_caller_address(contract_address);
}

#[test]
#[should_panic(expected: ('Account is closed',))]
fn test_withdraw_from_closed_account() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Grace";
    let address: ContractAddress = 'Grace'.try_into().unwrap();

    let recipient_name: ByteArray = "Hank";
    let recipient_address: ContractAddress = 'Hank'.try_into().unwrap();

    // Create accounts and deposit
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    contract_instance.deposit(300);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    stop_cheat_caller_address(contract_address);

    // Close Grace's account
    start_cheat_caller_address(contract_address, address);
    contract_instance.close_account(recipient_address);

    // Try to withdraw from closed account - should panic
    contract_instance.withdraw(100);
    stop_cheat_caller_address(contract_address);
}

#[test]
#[should_panic(expected: ('Account is closed',))]
fn test_transfer_from_closed_account() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Ivy";
    let address: ContractAddress = 'Ivy'.try_into().unwrap();

    let recipient_name: ByteArray = "Jack";
    let recipient_address: ContractAddress = 'Jack'.try_into().unwrap();

    // Create accounts and deposit
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    contract_instance.deposit(300);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    stop_cheat_caller_address(contract_address);

    // Close Ivy's account
    start_cheat_caller_address(contract_address, address);
    contract_instance.close_account(recipient_address);

    // Try to transfer from closed account - should panic
    contract_instance.transfer(100, recipient_address);
    stop_cheat_caller_address(contract_address);
}

// Test insufficient balance for withdrawal
#[test]
#[should_panic(expected: 'Insufficient balance')]
fn test_withdraw_insufficient_balance() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Oscar";
    let address: ContractAddress = 'Oscar'.try_into().unwrap();

    // Create account and deposit
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    contract_instance.deposit(200);

    // Try to withdraw more than balance - should panic
    contract_instance.withdraw(300);
    stop_cheat_caller_address(contract_address);
}

// Test insufficient balance for transfer
#[test]
#[should_panic(expected: 'Insufficient balance')]
fn test_transfer_insufficient_balance() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Peter";
    let address: ContractAddress = 'Peter'.try_into().unwrap();

    let recipient_name: ByteArray = "Quinn";
    let recipient_address: ContractAddress = 'Quinn'.try_into().unwrap();

    // Create accounts
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    contract_instance.deposit(150);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    stop_cheat_caller_address(contract_address);

    // Try to transfer more than balance - should panic
    start_cheat_caller_address(contract_address, address);
    contract_instance.transfer(200, recipient_address);
    stop_cheat_caller_address(contract_address);
}

// Test transfer to closed account
#[test]
#[should_panic(expected: 'Recipient account is closed')]
fn test_transfer_to_closed_account() {
    let contract_address = setup();
    let contract_instance = ISimpleBankDispatcher { contract_address };

    let name: ByteArray = "Robert";
    let address: ContractAddress = 'Robert'.try_into().unwrap();

    let recipient_name: ByteArray = "Sara";
    let recipient_address: ContractAddress = 'Sara'.try_into().unwrap();

    let third_name: ByteArray = "Tom";
    let third_address: ContractAddress = 'Tom'.try_into().unwrap();

    // Create accounts
    start_cheat_caller_address(contract_address, address);
    contract_instance.open_account(name);
    contract_instance.deposit(300);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.open_account(recipient_name);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, third_address);
    contract_instance.open_account(third_name);
    stop_cheat_caller_address(contract_address);

    // Close Sara's account
    start_cheat_caller_address(contract_address, recipient_address);
    contract_instance.close_account(third_address);
    stop_cheat_caller_address(contract_address);

    // Try to transfer to closed account - should panic
    start_cheat_caller_address(contract_address, address);
    contract_instance.transfer(100, recipient_address);
    stop_cheat_caller_address(contract_address);
}

