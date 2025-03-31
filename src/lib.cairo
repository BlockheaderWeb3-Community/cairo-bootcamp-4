// Import the math_operations module
mod math;
use math::math_operations::{
    add, divide, even_or_odd_sum, is_odd, max_of_two, multiply, number_sign, subtract,
};

fn main() {
    let a = 10;
    let b = 5;
    let c = -5;

    let sum = add(a, b); // Calculate sum
    let sub = subtract(a, b); // Calculate subtraction
    let product = multiply(a, b); // Calculate multiplication
    let division = divide(a, b); // Calculate division
    let even = even_or_odd_sum(0, 2); // Check if sum is even
    let odd = is_odd(b); // Check if number is odd   
    let max = max_of_two(a, b); // Find the maximum of two numbers

    // Print results
    println!("The sum is {}", sum);
    println!("The difference is {}", sub);
    println!("The product is {}", product);
    println!("The division result is {}", division);
    println!("The even or odd result is {}", even);
    println!("The result is odd: {}", odd);
    number_sign(c); // Determine the sign of a number
    println!("The max result is {}", max);
}
