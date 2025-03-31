
mod math_operations{
    // define a function that can be accesses outside this module 
    pub fn subtract(x: i32, y: i32) -> i32{
        // subtract and return the res
        x-y
    }

    pub fn multiply(x: i32, y: i32) ->i32{
        x*y
    }

    pub fn divide(x: i32, y: i32){
        // condition to handle an edge case where there is a denominator of zero
        if(y==0){
            println!("Division by zero is undefined!");
            return;
        }

        let res = x / y;
        println!("{}", res)
    }
}