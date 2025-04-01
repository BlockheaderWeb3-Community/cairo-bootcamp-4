mod Arithemetic_operation;
use crate::Arithemetic_operation::operation::{
    divide_num, even_numbers, isEven_or_isOdd, is_even, is_odd, multiply_num,
    subtract_num, sum_num, 
};


fn main() {


    // sum two u8 integer
    let sum = sum_num(10, 8);
    println!("the sum of {}", sum);

    // add  two u8 integers
    let multiplication = multiply_num(7, 8);
    println!("the multiplication of {}", multiplication);

    // subtract  two u8 integers

    let subtraction = subtract_num(10, 7);
    println!("the subtraction of {}", subtraction);

    // divide two u8 integers

    let division = divide_num(15, 5);
    println!("the division of {}", division);

    // check for even number

    let even = is_even(9);
    println!("the even number {}", even);

    // check for odd number
    let even = is_odd(9);
    println!("the odd number {}", even);

    // check for even or odd number
    let isEven = isEven_or_isOdd(6);
    println!("the number is {}", isEven);

    // check for the sum  even or odd number
    let isOdd = even_numbers(5, 8);
    println!("the number is {}", isOdd);   

    // to check greater than 50
  //  let greater = is_greater_than_50(55);
    //println!("the number is {}", greater);
}