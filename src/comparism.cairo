pub mod compare {
    pub fn comparism_operator(x: i128) {
        if x >= 0 && x % 2 == 0 {
            // return true;
            println!("{} is a positive number and a even number", x);
        }
        if x >= 0 && x % 2 != 0 {
            // return false;
            println!("{} is a positive number and a odd number", x);
        }

        if x < 0 && x % 2 == 0 {
            // return false;
            println!("{} is a negative number and a even number", x);
        }

        if x < 0 && x % 2 != 0 {
            // return false;
            println!("{} is a negative number and a odd number", x);
        }
    }
}
