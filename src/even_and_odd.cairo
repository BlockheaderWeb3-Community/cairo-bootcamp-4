mod even_and_odd{

    pub fn is_sum_even(x: i32, y: i32){
        // storing the result of x + y in the sum variable 
        let sum = x + y;
        // condition checking if the result of the sum is even or odd   
        if(sum % 2 == 0){
            // if even print true
        println!("{true}");
        }else{
            // if odd print odd
        println!("{false}");
        }
    }


    pub fn is_odd(x: i32){
        // condition checking to see if x is not an even number
        if(x % 2 != 0 ){
            // if odd print true
            println!("{true}");
        }else{
            // if even print true
            println!("{false}");
        }
    }
}