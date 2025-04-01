


use core::option::OptionTrait;
//The line use core::option::OptionTrait; in Cairo is used to import the OptionTrait from the core::option module. This trait provides utility methods for working with the Option type in Cairo.

//What is Option in Cairo?
//The Option type is used to represent a value that can either:

//Contain a value (Option::Some(value)), or
//Be empty (Option::None).
//This is useful for handling cases where a value might be absent, such as the result of a division operation where the divisor is zero.

//What does OptionTrait do?
//The OptionTrait provides methods to work with Option values. For example:

//unwrap_or: Returns the contained value if it exists, or a default value if it is None.
//is_some: Checks if the Option contains a value.
//is_none: Checks if the Option is empty.


mod arithmetic;
mod even_odd;
mod odd_checker;
mod logic;

use arithmetic::{subtract, multiply, divide};
use even_odd::even_or_odd_sum;
use odd_checker::is_odd;
use logic::{check_number_sign, max_of_two};

fn main() {
    // Arithmetic Operations
    let sub_result = subtract(10, 4);
    let mul_result = multiply(5, 3);
    let div_result = divide(20, 5);
    let div_by_zero = divide(20, 0);

    // Print arithmetic results
    println!("Subtraction: {}", sub_result);
    println!("Multiplication: {}", mul_result);
    
    // Handle division results
    match div_result {
        Option::Some(value) => println!("Division: {}", value),
        Option::None => println!("Error: Division by zero"),
    }
    
    match div_by_zero {
        Option::Some(value) => println!("Division: {}", value),
        Option::None => println!("Error: Division by zero"),
    }

    // Even or Odd Sum
    let sum_result = even_or_odd_sum(4, 7);
    println!("Sum of 4 and 7 is: {}", sum_result);

    // Odd Number Checker
    let num = 9;
    if is_odd(num) {
        println!("{} is Odd", num);
    } else {
        println!("{} is Even", num);
    }

    // Logic Functions
    let negative_num: i32 = -5;
    println!("Sign of -5: {}", check_number_sign(negative_num));
    println!("Maximum of 12 and 18: {}", max_of_two(12, 18));
}