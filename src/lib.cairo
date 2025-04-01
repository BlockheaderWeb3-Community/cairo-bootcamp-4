mod mod_math;
use mod_math::ModMath;

fn main() {
    let a = 21;
    let b = 4;
    let sub = ModMath::subtract_numbers(a, b);
    let mul = ModMath::multiply_numbers(a, b);
    let div = ModMath::divide_numbers(a, b);
    let even_or_odd = ModMath::even_or_odd_sum(a, b);
    let first_odd_num = ModMath::first_num_is_odd(a);
    let second_odd_num = ModMath::second_num_is_odd(b);
    let positive_num = ModMath::positive_number(a);
    let max_num = ModMath::num_is_max(a,b);

    //Output
    println!("Subtraction: {}", sub);
    println!("Multiplication: {}", mul);
    println!("Division: {}", div);
    println!("Sum_is_Even:{}", even_or_odd);
    println!("First_Number_is_Odd:{}", first_odd_num);
    println!("Second_Number_is_Odd:{}", second_odd_num);
    println!("Positive_Number:{}", positive_num);
    println!("Maximum_Number:{}", max_num);
}