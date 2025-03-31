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
    even_or_odd_sum(4, 6);
    even_or_odd_sum(3, 4);
    odd_number_checker(5);
    let difference = subtraction(num_2, num_1);
    println!("The difference between {num_1} and {num_2} is: {}", difference);

    let product = multiplication(num_1, num_2);  
     println!("The product of {num_1} and {num_2} is: {}", product);  

    let max_number = max_number(num_1, num_2);
    println!("The max btw {num_1} and {num_2} is: {}", max_number); 

    sign_checker(5);
    sign_checker(0);
    sign_checker(-10);


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
fn even_or_odd_sum(x:u8, y:u8){
    let sum = x + y;
    let check = sum % 2;

    if (check == 1){
        println!("The sum of {x} and {y} is odd");
    }else{
        println!("The sum of {x} and {y} is even");
    }
}
fn odd_number_checker(y:u8){
    let check = y % 2;

    if (check == 1){
        println!("The number of {y} is odd");
    }else{
        println!("The number of {y} is not odd");
    }
}


fn subtraction(x:u8, y:u8) -> u8{
    assert!(x > y, "Invalid valuess");
    let diff = x - y;
    return diff;
    // println!("The difference between {x} and {y} is: {}", total);
}

fn division(x:u8, y:u8) -> u8{
    assert!(y > 0, "should be greater than 0");
    let result = x / y;
    return result;
    // println!("The divison of {x} by {y} is: {}", result);
}

fn multiplication(x:u8, y:u8) -> u8{
    let result = x * y;
    return result;
    // println!("The product of {x} and {y} is: {}", result);
}

fn max_number(x:u8, y:u8)-> u8{
    if (y > x){
        return y;
    } else {
        return x; 
    }
}

fn sign_checker(x: i32){
    if (x > 0){
        println!("the number is positive");
    }else if(x < 0){
        println!("the number is negative");
    }else{
        println!("The number is zero");
    }
}


