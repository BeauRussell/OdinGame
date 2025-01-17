package main

import "engine"

main :: proc() {
    engine.init()
    defer engine.shutdown()

	character_pos := engine.EntityPosition{
		x = 500,
		y = 500
	}
    for engine.running() {
		engine.apply_gravity(&character_pos)
		engine.check_input(&character_pos)

        engine.render(character_pos)
    }
}
