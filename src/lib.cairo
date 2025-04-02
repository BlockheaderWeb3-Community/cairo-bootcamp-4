fn main() {
    let multiply = multiplication(2, 10);
    let div = division(0, 2);
    let checker = sign_checker(6);
    let odd = is_odd(3);
    let max = max_num(6, 7);
    let even_or_odd = even_odd_sum(3, 6);
    let sub = subtraction(10, 2);

    println!("multiplication is equal to {}", multiply);
    println!("checker is equal to {}", checker);
    println!("odd is equal to {}", odd);
    println!("max is equal to {}", max);
    println!("even_or_odd is equal to {}", even_or_odd);
    println!("sub is equal to {}", sub);

    match div {
        Option::Some(value) => println!("answer is {}", value),
        Option::None => println!("this is an error operation"),
    }
}


// this function subtracts between two numbers
pub fn subtraction(x: u128, y: u128) -> u128 {
    return x - y;
}

// this function multipli_es two numbers
pub fn multiplication(x: i16, y: i16) -> i16 {
    return x * y;
}

// this function divides two numbers
pub fn division(x: i16, y: i16) -> Option<i16> {
    if y == 0 {
        return Option::None;
    } else if x == 0 {
        return Option::None;
    } else {
        return Option::Some(x / y);
    }
}

// thi function checks if a number is positive, negative, or equal to zero
pub fn sign_checker(x: i16) -> ByteArray {
    let num = x;
    if num > 0 {
        return "positive";
    } else if num < 0 {
        return "negative";
    } else {
        return "zero";
    }
}

// this function picks the maximum number between two numbers
pub fn max_num(x: i16, y: i16) -> i16 {
    if x > y {
        return x;
    } else {
        return y;
    }
}

// pub is used to make a mod or function public andvisible to parent functions
// pub mod even_or_odd_sum;

// this function determines whether a value is odd or not
pub fn is_odd(x: i16) -> bool {
    return x % 2 != 0;
}


// this function checksif the result of the sum of two numbers is even or odd
pub fn even_odd_sum(x: i16, y: i16) -> ByteArray {
    let add = x + y;
    let odd = is_odd(add);
    let res = true;
    if odd == res {
        return "odd";
    } else {
        return "even";
    }
}

