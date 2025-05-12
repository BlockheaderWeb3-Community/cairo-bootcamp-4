#[cfg(test)]
mod tests {
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelStorageTest};
    use dojo::world::{WorldStorageTrait, WorldStorage};
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef,
    };
    use dojo_starter::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use dojo_starter::models::{Position, m_Position, Player, m_Player, Direction};

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "dojo_starter",
            resources: [
                TestResource::Model(m_Position::TEST_CLASS_HASH),
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Event(actions::e_Moved::TEST_CLASS_HASH),
                TestResource::Contract(actions::TEST_CLASS_HASH),
            ]
                .span(),
        };

        ndef
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"dojo_starter", @"actions")
                .with_writer_of([dojo::utils::bytearray_hash(@"dojo_starter")].span())
        ]
            .span()
    }

    fn setup_world() -> (WorldStorage, IActionsDispatcher) {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        (world, actions_system)
    }


    #[test]
    #[available_gas(30000000)]
    fn test_move() {
        let caller = starknet::contract_address_const::<0x0>();

        let (world, actions_system) = setup_world();

        actions_system.spawn();
        let player: Player = world.read_model(caller);
        let position: Position = world.read_model(caller);

        assert(
            player.score == 1 && position.vec.x == 0 && position.vec.y == 0,
            'wrong initial position',
        );

        // actions_system.move(Direction::Right(()));
        actions_system.move(Direction::Down(()));

        let new_position: Position = world.read_model(caller);
        assert_eq!(new_position.vec.x, position.vec.x);
        assert_eq!(new_position.vec.y, position.vec.y + 1);
    }
}
