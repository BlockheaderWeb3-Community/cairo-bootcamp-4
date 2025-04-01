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
pub fn max_num(x: i16, y: i16) -> i16{
    if x > y {return x;}
    else {return y;}
}