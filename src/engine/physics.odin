package engine

import "core:fmt"
import "../pkg"

LATERAL_MOVEMENT_MULTIPLIER :: 0.0035
GRAVITY :: 0.45

move_left :: proc(entity_pos: ^EntityPosition) {
	entity_pos.x -= u16(f16(pkg.settings.window.width) * LATERAL_MOVEMENT_MULTIPLIER)
}

move_right :: proc(entity_pos: ^EntityPosition) {
	entity_pos.x += u16(f16(pkg.settings.window.width) * LATERAL_MOVEMENT_MULTIPLIER)
}

jump :: proc(entity_pos: ^EntityPosition) {
	entity_pos.vertical_velocity = -10
	entity_pos.y -= 10
}

apply_gravity  :: proc(entity_pos: ^EntityPosition) {
	if entity_pos.y >= u16(pkg.settings.window.height - 100) {
		entity_pos.vertical_velocity = 0
		return
	}

	if entity_pos.vertical_velocity <= 10 {
		entity_pos.vertical_velocity += GRAVITY
	}
	entity_pos.y += u16(entity_pos.vertical_velocity)
	fmt.println(entity_pos.vertical_velocity)
}
