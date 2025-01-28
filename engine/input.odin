package engine

import "vendor:raylib"
import "core:fmt"
import "../pkg"



check_input :: proc (character_position: ^EntityPosition) {
	if raylib.IsKeyDown(.LEFT) || raylib.IsKeyDown(.A) {
		move_left(character_position)
	}
	if raylib.IsKeyDown(.RIGHT) || raylib.IsKeyDown(.D) {
		move_right(character_position)
	}
	if raylib.IsKeyPressed(.UP) || raylib.IsKeyPressed(.W) || raylib.IsKeyPressed(.SPACE) {
		jump(character_position)
	}
}
