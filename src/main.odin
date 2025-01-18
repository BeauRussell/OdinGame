package main

import "engine"
import "render"

main :: proc() {
    render.init()
    defer render.shutdown()

	character_pos := engine.EntityPosition{
		x = 500,
		y = 500
	}
    for render.running() {
		engine.apply_gravity(&character_pos)
		engine.check_input(&character_pos)

        render.render(character_pos)
    }
}
