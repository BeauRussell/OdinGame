package main

import "core:log"
import "core:mem"
import "engine"
import "render"

main :: proc() {
	context.logger = create_logger()
	defer log.destroy_console_logger(context.logger)
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)
	defer log_leaks(&track) 

	log.info("Starting up")

    render.init()
    defer render.shutdown()

	character_pos := engine.EntityPosition{
		x = 500,
		y = 500,
	}
    for render.running() {
		engine.apply_gravity(&character_pos)
		engine.check_input(&character_pos)

        render.render(character_pos)
    }
}

log_leaks :: proc(track: ^mem.Tracking_Allocator) {
	if len(track^.allocation_map) > 0 {
		for _, entry in track^.allocation_map {
			log.infof("%v leaked %v bytes\n", entry.location, entry.size)
		}
	}
	if len(track^.bad_free_array) > 0 {
		for entry in track^.bad_free_array {
			log.infof("%v bad free at %v\n", entry.location, entry.memory)
		}
	}

	mem.tracking_allocator_destroy(track)
}

create_logger :: proc() -> log.Logger {
	return log.create_console_logger()
}
