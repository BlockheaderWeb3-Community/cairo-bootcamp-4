// function to perform basic Substraction arithmetic operation

pub fn subtractNum(x: u16, y: u16, z: u16) -> u16 {
    let result: u16 = x - y - z;
    return result;
}

// function to perform basic multiplication arithmetic operation
pub fn multiplyNum(x: u16, y: u16) -> u16 {
    let result: u16 = x * y;
    result
}

// function to perform basic division arithmetic operation
pub fn divideNum(x: u16, y: u16) -> u16 {
    let result = (x / y);
    result
}

// function to check if the sum of two numbers is even
pub fn is_sum_even(x: u16, y: u16) -> bool {
    let sum = x + y;
    sum % 2 == 0
}

// function to check if a number is odd WITH println
pub fn is_odd(num: u16) -> bool {
    if num % 2 == 0 {
        println!("The number {} is even", num);
        false
    } else {
        println!("The number {} is odd", num);
        true
    }
}


// function to check if a number is positive, negative, or zero
pub fn check_num(num: i16) {
    if num > 0 {
        println!("The number is positive");
    } else if num < 0 {
        println!("The number is negative");
    } else {
        println!("The number is zero");
    }
}

// function to return the maximum of two numbers.
pub fn max_num(x: u16, y: u16) -> u16 {
    if x > y {
        println!("The maximum number is {}", x);
        return x;
    } else {
        println!("The maximum number is {}", y);
        return y;
    }
}