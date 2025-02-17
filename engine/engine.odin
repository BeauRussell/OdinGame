package engine

Vec2 :: [2]f32

Box :: struct {
	x: f32,
	y: f32,
	width: f32,
	height: f32,
}

Move_Options :: enum {
	Right,
	Left,
	Jump,
}

Player_State :: enum {
	Idle,
	Jumping,
}

User_Data :: struct {
	state: Player_State,
}
