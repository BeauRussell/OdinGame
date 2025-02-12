package engine

import rl "vendor:raylib"

check_move_input :: proc() {
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		move_player(.Right)
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		move_player(.Left)
	}
	if rl.IsKeyPressed(.SPACE) || rl.IsKeyPressed(.W) || rl.IsKeyPressed(.UP) {
		move_player(.Jump)
	}
}
