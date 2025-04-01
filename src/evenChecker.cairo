


pub mod even_logic {
    
    pub fn even_checker(x: u256, y: u256) -> bool{
       let sum = x + y;
       if sum % 2 == 0 {
           return true;
           // println!("The result is an EVEN Number");
       }else{
           return false;
           // println!("The result is an ODD Number")
       }
   }
   
   }