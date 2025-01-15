package main

import "engine"

main :: proc() {
    engine.init()
    defer engine.shutdown()

	character_pos := engine.EntityPosition{
		x = 100,
		y = 100
	}
    for engine.running() {

        engine.render(character_pos)
    }
}
