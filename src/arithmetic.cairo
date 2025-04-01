
use core::option::OptionTrait;

// Function to subtract two numbers
pub fn subtract(a: u32, b: u32) -> u32 {
    if a >= b {
        a - b
    } else {
        0 // In Cairo, we need to handle underflow carefully
    }
}

// Function to multiply two numbers
pub fn multiply(a: u32, b: u32) -> u32 {
    a * b
}

// Function to divide two numbers
pub fn divide(a: u32, b: u32) -> Option<u32> {
    if b == 0 {
        Option::None // Return None for division by zero
    } else {
        Option::Some(a / b) // Return Some(result) for valid division
    }
}