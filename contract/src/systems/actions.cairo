use dojo_starter::models::{Direction, Position};

// define the interface
#[starknet::interface]
pub trait IActions<T> {
    fn spawn(ref self: T);
    fn move(ref self: T, direction: Direction);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, Direction, Position, get_next_position};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use origami_random::dice::{DiceTrait};
    use dojo_starter::models::{Vec2, Player};

    use dojo::model::{ModelStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub direction: Direction,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        // Create a new player and set their initial position and bag position 
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world_default();

            let caller = get_caller_address();

            let player: Player = world.read_model(caller);

            assert(player.score < 1, 'Already spawned');

            let new_player = Player { player: caller, score: 1, next_bag: Vec2 { x: 7, y: 0 } };
            let new_position = Position { player: caller, vec: Vec2 { x: 0, y: 0 } };

            world.write_model(@new_player);
            world.write_model(@new_position);
        }

       // Move a player from current position to another position
        fn move(ref self: ContractState, direction: Direction) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world_default();

            let caller = get_caller_address();

            let mut player: Player = world.read_model(caller);

            // Player with score = 0 has not yet spawned
            assert(player.score > 0, 'Player needs to spawn');

            let mut position: Position = world.read_model(caller);

            // Calculate the player's next position based on the provided direction.
            let mut next_position: Position = get_next_position(position, Option::Some(direction));
            
            // Write the new position to the world.
            world.write_model(@next_position);

            // Player hits the bag
            if (next_position.vec.x == player.next_bag.x
                && next_position.vec.y == player.next_bag.y) {
                // Get next random position for player
                let (x, y) = self.get_random_position(player);

                // Update player
                player.next_bag.x = x;
                player.next_bag.y = y;
                player.score += 1;

                world.write_model(@player);
            }

            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player: caller, direction });
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "dojo_starter". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"dojo_starter")
        }

        // Get a random position
        fn get_random_position(ref self: ContractState, player: Player) -> (u8, u8) {
            let mut mixer = 1;
            let mut x = 0;
            let mut y = 0;

            loop {
                let seed = get_block_timestamp();

                let mut dice1 = DiceTrait::new(6, (seed + mixer).try_into().unwrap());
                let mut dice2 = DiceTrait::new(6, (seed + mixer + 1).try_into().unwrap());

                x = dice1.roll();
                y = dice2.roll();

                if (x != player.next_bag.x && y != player.next_bag.y) {
                    break;
                }

                mixer += 1;
            };

            (x, y)
        }
    }
}

// Define function like this:
fn get_next_position(mut position: Position, direction: Option<Direction>) -> Position {
    match direction {
        Option::None => { return position; },
        Option::Some(d) => match d {
            Direction::Left => { position.vec.x -= 1; },
            Direction::Right => { position.vec.x += 1; },
            Direction::Up => { position.vec.y -= 1; },
            Direction::Down => { position.vec.y += 1; },
        },
    };
    position
}
