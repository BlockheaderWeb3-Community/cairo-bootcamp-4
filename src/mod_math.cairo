pub mod ModMath {
    //subtraction function
    pub fn subtract_numbers(a: u8, b: u8) -> u8 {
        return a - b;
    }

    //multiplication function
    pub fn multiply_numbers(a: u8, b: u8) -> u8 {
        return a * b;
    }
    //division function
    pub fn divide_numbers(a: u8, b: u8) -> u8 {
        if a / b == 0 {
            return 0;
        } else {
            return a / b;
        }
    }
    //function to check if sum is even or odd
    pub fn even_or_odd_sum(a: u8, b: u8) -> bool {

        let sum = a + b;
        if (sum % 2 == 0)
            {return true;
            }else{
                return false;
            }

        }

        //function to check if first number is odd
        pub fn first_num_is_odd(a: u8) -> bool {
            if a % 2 == 0 {
                return false;
            } else {
                return true;
            }
    }

        pub fn second_num_is_odd(b: u8) -> bool {
            if b % 2 == 0 {
                return false;
            } else {
                return true;
            }
}

    //function to check for positive sign
    pub fn positive_number(a: u8) -> bool {
        if a > 0 {return true;}
        else {return false;}
    }

    //function to check for maximum number
    pub fn num_is_max(a: u8, b: u8) -> u8 {
        if a > b {return a;} else 
        {return b;}
        
    }
}

