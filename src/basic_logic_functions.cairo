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


pub fn max_num(x: i16, y: i16) -> i16{
    if x > y {return x;}
    else {return y;}
}