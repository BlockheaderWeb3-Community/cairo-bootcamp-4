
// Function to check if sum of two numbers is even or odd
pub fn even_or_odd_sum(a: u32, b: u32) -> felt252 {
    let sum = a + b;
    
    if sum % 2 == 0 {
        'Even'
    } else {
        'Odd'
    }
}