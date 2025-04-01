use crate::even_or_odd_checker::is_odd;

pub fn even_odd_sum(x: i16, y: i16) -> ByteArray {
    let add = x + y;
    let odd = is_odd(add);
    let res = true;
    if odd == res{ 
        return "odd";
    }else{
        return "even";
    }
}