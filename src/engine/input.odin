package engine

import "vendor:raylib"
import "core:fmt"
import "../pkg"

LATERAL_MOVEMENT_MULTIPLIER :: 0.0035


check_input :: proc (character_position: ^EntityPosition) {
	if raylib.IsKeyDown(.LEFT) || raylib.IsKeyDown(.A) {
		character_position.x -= i32(f16(pkg.settings.window.width) * LATERAL_MOVEMENT_MULTIPLIER)
	}
	if raylib.IsKeyDown(.RIGHT) || raylib.IsKeyDown(.D) {
		character_position.x += i32(f16(pkg.settings.window.width) * LATERAL_MOVEMENT_MULTIPLIER)
	}
}
