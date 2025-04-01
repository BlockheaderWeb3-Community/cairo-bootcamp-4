// this function subtracts two numbers
pub fn subtract(x: i16, y: i16) -> i16 {
    return x - y;
}

// this function multiplies two numbers
pub fn multiplication(x: i16, y: i16) -> i16 {
    return x * y;
}

// this function divides two numbers 
pub fn division(x: i16, y: i16) -> Option<i16> {
    if y == 0 {
        return Option::None;
    } else if x ==0 {
        return Option::None;
    } else {
        return Option::Some(x/y);
    }
}