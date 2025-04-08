// Solution to: 

// 2. Even or Odd Sum
// Implement a function that takes two arguments, computes their sum, and determines whether the sum is even or odd.

// 3. Odd Number Checker
// Implement a function that checks if a given number is odd.

pub fn is_sum_even(x: i32, y: i32) {
    // storing the result of x + y in the sum variable
    let sum = x + y;
    // checking if the result of the sum is even or odd
    if sum % 2 == 0 {
        // if even print true
        println!("{true}");
    } else {
        // if odd print odd
        println!("{false}");
    }
}

pub fn is_odd(x: i32) {
    // checking to see if x is not an even number
    if x % 2 != 0 {
        // if odd print true
        println!("{true}");
    } else {
        // if even print true
        println!("{false}");
    }
}
