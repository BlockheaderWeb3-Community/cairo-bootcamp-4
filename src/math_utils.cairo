pub mod MathUtils {
    // function to subtract two numbers
    pub fn subtract_numbers(x: u8, y: u8) -> u8 {
        return x - y;
    }

    // function to divide two numbers
    pub fn divide_numbers(x: u8, y: u8) -> u8 {
        if y == 0 {
            return 0;
        }else {
            return x / y;
        }
    }

    // function to multiply two numbers
    pub fn multiply_numbers(x: u8, y: u8) -> u8 {
        return x * y;
    }
    // function to check if a number is even or odd
    pub fn is_even_or_odd(x: u8, y: u8) -> bool {
        if x % 2 == 0 {
            return true;
        } else {
            return false;
        }
    }
    // function to check if a number is odd
    pub fn is_odd(x: u8) -> bool {
        if x % 2 == 0 {
            return false;
        } else {
            return true;
        }
    }
    // function to check if a number is positive
    pub fn is_positive(x: i8) -> ByteArray {
        if x > 0 {
            return "positive";
        } else if x == 0 {
            return "zero";
        } else {
            return "negative";
        }
    }
    // function to check the maximum of two numbers
    pub fn is_max(x:u8, y:u8) -> u8 {
        if x > y {
            return x;
        } else {
            return y;
        }
    }
}