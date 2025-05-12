// @ts-nocheck
import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { CairoCustomEnum, BigNumberish } from 'starknet';

// Type definition for `dojo_starter::models::Player` struct
export interface Player {
	player: string;
	score: BigNumberish;
	next_bag: Vec2;
}

// Type definition for `dojo_starter::models::PlayerValue` struct
export interface PlayerValue {
	score: BigNumberish;
	next_bag: Vec2;
}

// Type definition for `dojo_starter::models::Position` struct
export interface Position {
	player: string;
	vec: Vec2;
}

// Type definition for `dojo_starter::models::PositionValue` struct
export interface PositionValue {
	vec: Vec2;
}

// Type definition for `dojo_starter::models::Vec2` struct
export interface Vec2 {
	x: BigNumberish;
	y: BigNumberish;
}

// Type definition for `dojo_starter::systems::actions::actions::Moved` struct
export interface Moved {
	player: string;
	direction: DirectionEnum;
}

// Type definition for `dojo_starter::systems::actions::actions::MovedValue` struct
export interface MovedValue {
	direction: DirectionEnum;
}

// Type definition for `dojo_starter::models::Direction` enum
export const direction = [
	'Left',
	'Right',
	'Up',
	'Down',
] as const;
export type Direction = { [key in typeof direction[number]]: string };
export type DirectionEnum = CairoCustomEnum;

export interface SchemaType extends ISchemaType {
	dojo_starter: {
		Player: Player,
		PlayerValue: PlayerValue,
		Position: Position,
		PositionValue: PositionValue,
		Vec2: Vec2,
		Moved: Moved,
		MovedValue: MovedValue,
	},
}
export const schema: SchemaType = {
	dojo_starter: {
		Player: {
			player: "",
		score: 0,
		next_bag: { x: 0, y: 0, },
		},
		PlayerValue: {
		score: 0,
		next_bag: { x: 0, y: 0, },
		},
		Position: {
			player: "",
		vec: { x: 0, y: 0, },
		},
		PositionValue: {
		vec: { x: 0, y: 0, },
		},
		Vec2: {
			x: 0,
			y: 0,
		},
		Moved: {
			player: "",
		direction: new CairoCustomEnum({ 
					Left: "",
				Right: undefined,
				Up: undefined,
				Down: undefined, }),
		},
		MovedValue: {
		direction: new CairoCustomEnum({ 
					Left: "",
				Right: undefined,
				Up: undefined,
				Down: undefined, }),
		},
	},
};
export enum ModelsMapping {
	Player = 'dojo_starter-Player',
	PlayerValue = 'dojo_starter-PlayerValue',
	Position = 'dojo_starter-Position',
	PositionValue = 'dojo_starter-PositionValue',
	Vec2 = 'dojo_starter-Vec2',
	Direction = 'dojo_starter-Direction',
	Moved = 'dojo_starter-Moved',
	MovedValue = 'dojo_starter-MovedValue',
}