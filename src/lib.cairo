// Importing then

mod arithmetic_operations;
mod basic_logic_functions;
mod even_and_odd;

// Importing then
use arithmetic_operations::{subtract, multiply, divide};
use basic_logic_functions::{sign_checker, larger_num};
use even_and_odd::{is_sum_even, is_odd};



fn main() {
    // using imported functions in my main file
    is_sum_even(4, 7);
    is_odd(3);
    sign_checker(-3);
    larger_num(2, 6);
    let sub_res: i32 = subtract(9, 1);
    println!("subtraction result: {sub_res}");

    let mul_res = multiply(15, 2);
    println!("multiplication result: {mul_res}");

    divide(3, 10);
  
}




