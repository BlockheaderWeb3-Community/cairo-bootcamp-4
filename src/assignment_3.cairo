fn main() {
    // Function calls
    add_numbers(34, 23);
    subtract_numbers(23, 34);
    is_sum_even_or_odd(5);
    is_odd(22);
}

// Adds two numbers and returns the sum
fn add_numbers(x: i32, y: i32) -> i32 {
    return x + y;
}

// Subtracts second number from the first and returns the difference
fn subtract_numbers(x: i32, y: i32) -> i32 {
    return x - y;
}

// Multiplies two numbers and returns the product
fn multiply_numbers(x: i32, y: i32) -> i32 {
    return x * y;
}

// Checks if a number is even (returns true if even, false if odd)
fn is_sum_even_or_odd(x: i32) -> bool {
    return x % 2 == 0;
}

// Checks if a number is odd (returns true if odd, false if even)
fn is_odd(x: i32) -> bool {
    return x % 2 != 0;
}

// Classifies a number as positive, negative, or zero
fn classify_number(x: i32) {
    if x > 0 {
        println!("The number '{}' is positive", x);
    } else if x < 0 {
        println!("The number '{}' is negative", x);
    } else {
        println!("The number '{}' is definitely a zero", x);
    }
}

// Returns the maximum of two numbers
fn max_of_two(x: i32, y: i32) -> i32 {
    if x < y {
        return y;
    } else {
        return x;
    }
}
