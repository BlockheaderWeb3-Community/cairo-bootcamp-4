pub mod operation {
    // Function to sum two u8 integer
    pub fn sum_num(x: u8, y: u8) -> u8 {
        return x + y;
    }


    // Function to add   u8 integers
    pub fn multiply_num(x: u8, y: u8) -> u8 {
        return x * y;
    }


    // Function to subtract   u8 integers
    pub fn subtract_num(x: u8, y: u8) -> u8 {
        return x - y;
    }

    // Function to divide  two u8 integers
    pub fn divide_num(x: u8, y: u8) -> u8 {
        return x / y;
    }

    // Function to check even  u8 integers
    pub fn is_even(x: u8) -> bool {
        x % 2 == 0
    }

    // Function to check odd  u8 integers
    pub fn is_odd(x: u8) -> bool {
        x % 2 == 1
    }
    // Function to check even or odd of one number  u8 integers
    pub fn isEven_or_isOdd(x: u8) -> bool {
        if x % 2 == 0 {
            println!("Even");
            return true;
        }
        println!("odd");
        return false;
    }


    // Function to check even or odd of sum  number  u8 integers
    pub fn even_numbers(x: u8, y: u8) -> bool {
        if (x + y) % 2 == 0 {
            println!("Even");

            return true;
        }
        println!("odd");
        return false;
    }

    // Function to check if a u32 integer is greater than 50
    pub fn is_greater_than_50(x: u32) -> bool {
        if x > 50 {
            println!("true");
            return true;
        }
        println!("false");
        return false;
    }

    //  to check for positive and negative

    pub fn sign_check(x: i8) -> bool {
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
    pub fn maximum_numb(x: u8, y: u8) -> u8 {
        if x > y {
            return x;
        }
        return y;
    }
}


fn say_name(x: ByteArray) {
    println!("{}", x);
}
// Function to demonstrate felt252 usage
fn intro_to_felt() {
    let x = 40000;
    println!("{}", x);
}
// Function to print a u16 integer
fn check_u16(x: u16) {
    println!("{x}");
}

