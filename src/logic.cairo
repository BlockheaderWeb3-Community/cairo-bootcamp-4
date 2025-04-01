
// Function to check the sign of a number
pub fn check_number_sign(num: i32) -> felt252 {
    if num > 0 {
        'Positive'
    } else if num < 0 {
        'Negative'
    } else {
        'Zero'
    }
}

// Function to find the maximum of two numbers
pub fn max_of_two(a: u32, b: u32) -> u32 {
    if a > b {
        a
    } else {
        b
    }
}