pub mod math_operations {
    // Function to add two numbers
    pub fn add(a: u8, b: u8) -> u8 {
        return a + b;
    }

    // Function to subtract the second number from the first
    pub fn subtract(a: u8, b: u8) -> u8 {
        return a - b;
    }

    // Function to multiply two numbers
    pub fn multiply(a: u8, b: u8) -> u8 {
        return a * b;
    }

    // Function to divide the first number by the second
    pub fn divide(a: u8, b: u8) -> u8 {
        if b == 0 {
            return 0;
        } else {
            return a / b;
        }
    }

    // Function to check if the sum of two numbers is even
    // Returns true if even, false if odd
    pub fn even_or_odd_sum(a: u8, b: u8) -> bool {
        let sum = a + b;
        if sum % 2 == 0 {
            return true;
        } else {
            return false;
        }
    }

    // Function to check if a number is odd
    // Returns true if the number is odd, false otherwise
    pub fn is_odd(a: u8) -> bool {
        if a % 2 != 0 {
            return true;
        } else {
            return false;
        }
    }

    // Function to determine the sign of a number
    // Returns 1 for positive numbers, -1 for negative numbers, and 0 for zero
    pub fn number_sign(a: i8) -> i8 {
        if a > 0 {
            return 1;
        } else if a < 0 {
            return -1;
        } else {
            return 0;
        }
    }

    // Function to find the maximum of two numbers
    pub fn max_of_two(a: u8, b: u8) -> u8 {
        if a > b {
            return a;
        } else {
            return b;
        }
    }
}
