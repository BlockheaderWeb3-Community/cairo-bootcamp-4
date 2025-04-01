fn main() {
    // Function calls (Uncomment to execute them)
    // say_name("Sylvia Nnoruka!");
    // intro_to_felt();

    let num_1 = 5;
    let num_2 = 10;
    let sum = sum_num(num_1, num_2);
    println!("The sum of {} and {} is = {}", num_1, num_2, sum);

    // check_u16(6553); // Uncomment if needed
    is_greater_than_50(3);

    println!("");
    println!("********* TASK 3 SOLUTIONS *********");
    println!("");
    
    // calling sub_num function
    let num1 = 15;
    let num2 = 12;
    let sub = sub_num(num1, num2);
    println!("The subtraction of {} and {} is = {}", num1, num2, sub);
    println!("");

    // calling mul_num
    let num1 = 12;
    let num2 = 14;
    let mul = mul_num(num1, num2);
    println!("The multiplication of {} and {} is = {}", num1, num2, mul);
    println!("");

    // calling div_num
    let num1 = 20;
    let num2 = 0;
    let div = div_num(num1, num2);
    match div {
        Option::Some(value) => println!("The division of {} and {} is = {}", num1, num2, value),
        Option::None => println!("The division of {} and {} is not possible", num1, num2),
    }
    println!("");

    // callint even or odd sum
    let num1 = 12;
    let num2 = 13;
    even_or_odd_sum(num1, num2);
    println!("");

    // calling is Odd
    let num3 = 14;
    is_odd(num3);
    println!("");

    // calling check_sign
    let num4 = 078;
    check_sign(num4);
    println!("");

    // calling max_num
    let num5 = 25;
    let num6 = 30;
    let max = max_num(num5, num6);
    println!("The maximum of {} and {} is = {}", num5, num6, max);
    println!("");

    // calling min number
    let num1 = 34;
    let num6 = 37;
    let min = min_num(num1, num6);
    println!("The minimum of {} and {} is = {}", num1, num6, min);
    println!("");

    println!("********* TASK 3 SOLUTIONS END *********");
}

// DATA TYPES IN CAIRO
// - felts: felt252 (Field elements)
// - ByteArray: Represents a sequence of bytes
// - Integers:
//   - Signed: i8, i16, i32, i64, i128, i256
//   - Unsigned: u8, u16, u32, u64, u128, u256
// - Boolean: bool

// Function to demonstrate ByteArray usage
fn say_name(x: ByteArray) {
    println!("{}", x);
}

// Function to demonstrate felt252 usage
fn intro_to_felt() {
    let x = 40000;
    println!("{}", x);
}

// Function to sum two u8 integers
fn sum_num(x: u8, y: u8) -> u8 {
    return x + y;
}

// Function to print a u16 integer
fn check_u16(x: u16) {
    println!("{x}");
}

// Function to check if a u32 integer is greater than 50
fn is_greater_than_50(x: u32) -> bool {
    if x > 50 {
        println!("true");
        return true;
    }
    println!("false");
    return false;
}


// TASK 3 SOLUTION
// 1 ARITHMETIC OPERATIONS
// - performs subtraction of two numbers
fn sub_num(x: u8, y: u8) -> u8 {
    return x - y;
}
// - performs multiplication of two numbers
fn mul_num(x: u8, y: u8) -> u8 {
    return x * y;
}
// - performs division of two numbers
fn div_num(x: u8, y: u8) -> Option<u8> {
    if y == 0{
        println!("Error: Division by zero is not allowed");
        return Option::None;
    } else if x == 0{
        println!("Error: Division by zero is not allowed");
        return Option::None;
    } 
    return Option::Some(x / y);
}

//  2 EVEN OR ODD SUM
// - checks if a number is even or odd from sum of two numbers
fn even_or_odd_sum(x: u8, y: u8) -> bool {
    let sum = x + y;
    if sum % 2 == 0 {
        println!("The sum of {} + {} is Even", x, y);
        return true;
    }
    println!("The sum of {} + {} is Odd", x, y);
    return false;
}


// 3 ODD NUMBER CHECKER
// - checks if a number is odd
fn is_odd(x: u8) -> bool {
    if x % 2 != 0 {
        println!("The number {} is Odd", x);
        return true;
    }
    println!("The number {} is Even", x);
    return false;
}

// 4 BASIC LOGIC FUNCTIONS
// Number Sign Checker
// - checks if a number is positive, negative or zero
fn check_sign(x: i8) -> bool {
    if x > 0 {
        println!("The number {} is Positive", x);
        return true;
    } else if x < 0 {
        println!("The number {} is Negative", x);
        return false;
    }
    println!("the number is Zero");
    return false;
}

// Maximum of two numbers
// - returns the maximum of two numbers
fn max_num(x: u8, y: u8) -> u8 {
    if x > y {
        return x;
    }
    return y;
}

// Minimum of two numbers
// - returns the minimum of two numbers
fn min_num(x: u8, y: u8) -> u8 {
    if x < y {
        return x;
    }
    return y;
}
