// pub is used to make a mod or function public andvisible to parent functions
pub mod even_or_odd_sum;

// this function determines whether a value is odd or not
pub fn is_odd(x: i16) -> bool {
    return x % 2 != 0;
}
