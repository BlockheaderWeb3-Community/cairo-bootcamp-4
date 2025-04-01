mod Task3;
use Task3::{
    subtractNum,
    multiplyNum,
    divideNum,
    is_sum_even,
    is_odd,
    check_num
};
   
fn main() {

    let num1: u16 = 10;
    let num2: u16 = 2;
    let num3: u16 = 3;

    // Perform subtraction
    let subtract: u16 = subtractNum(num1, num2, num3);
    println!("The difference bt {}, {} and {} is = {}", num1, num2, num3, subtract);

    // Perform multiplication
    let multiply: u16 = multiplyNum(num1, num2);
    println!("The multiplication of {} and {} is = {}", num1, num2, multiply);

    // Perform division
    let divide: u16 = divideNum(num1, num2);
    println!("The division of {} by {} is = {}", num1, num2, divide);

    // Check if the sum of two numbers is even
    let output = is_sum_even(num1, num2);
    if output {
        println!("The sum of {} and {} is even", num1, num2);
    } else {
        println!("The sum of {} and {} is odd", num1, num2);
    }
    // Check if a number is odd
    is_odd(num2);
    is_odd(num3);

    // Check if a number is positive, negative, or zero
    check_num(10);
    check_num(-2);
    check_num(0);

    // Function calls (Uncomment to execute them)
    // say_name("Sylvia Nnoruka!");
    // intro_to_felt();
    
    // let num_1 = 5;
    // let num_2 = 10;
    // let sum = sum_num(num_1, num_2);
    // println!("The sum of {} and {} is = {}", num_1, num_2, sum);
    
    // check_u16(6553); // Uncomment if needed
    // is_greater_than_50(3);
}

// DATA TYPES IN CAIRO
// - felts: felt252 (Field elements)
// - ByteArray: Represents a sequence of bytes
// - Integers:
//   - Signed: i8, i16, i32, i64, i128, i256
//   - Unsigned: u8, u16, u32, u64, u128, u256
// - Boolean: bool

// Function to demonstrate ByteArray usage
// fn say_name(x: ByteArray) {
//     println!("{}", x);
// }

// Function to demonstrate felt252 usage
// fn intro_to_felt() {
//     let x = 40000;
//     println!("{}", x);
// }

// Function to sum two u8 integers
// fn sum_num(x: u8, y: u8) -> u8 {
//     return x + y;
// }

// Function to print a u16 integer
// fn check_u16(x: u16) {
//     println!("{x}");
// }

// Function to check if a u32 integer is greater than 50
// fn is_greater_than_50(x: u32) -> bool {
//     if x > 50 {
//         println!("true");
//         return true;
//     }
//     println!("false");
//     return false;
// }
