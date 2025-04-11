pub mod odd_checker {
    pub fn odd_number_checker(x: u256) -> bool {
        if x % 2 != 0 {
            // return "odd number";
            return true;
        }
        // return "even number";
        return false;
    }
}
