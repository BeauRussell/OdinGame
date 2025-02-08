package main

import "core:log"
import "core:mem"

import rl "vendor:raylib"

import "engine"
import "pkg"
import "render"
import tracy "odin-tracy"

TARGET_FPS : i32 : 60
SUB_STEPS: i32 : 4

main :: proc() {
	tracy.SetThreadName("main")
	tracy.Zone()
	context.logger = create_logger()
	defer log.destroy_console_logger(context.logger)

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)
		defer log_leaks(&track)
	}

    render.init(TARGET_FPS)
    defer render.shutdown()

	world_id := engine.init_world()
	defer engine.destroy_world(world_id)

	ground := engine.Box{
		0, 32,
		60, 2 
	}

	engine.create_ground_body(ground)
	engine.create_player()
	last_pos: engine.Vec2

    for render.running() {
		defer tracy.FrameMark()
		tracy.ZoneN("Main Game Loop")
		render.start_render()

		rl.DrawRectangleRec(cast(rl.Rectangle)ground, rl.YELLOW)
		player_pos := engine.step_world(1.0 / f32(TARGET_FPS), SUB_STEPS)

		render.draw_player(player_pos)

		rl.EndMode2D()
		rl.EndDrawing()

		engine.check_move_input()
		defer check_fps()
    }
}

log_leaks :: proc(track: ^mem.Tracking_Allocator) {
	tracy.Zone()
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
	tracy.Zone()
	return log.create_console_logger()
}

check_fps :: proc() {
	tracy.Zone()
	if check_fps := rl.GetFPS(); check_fps < TARGET_FPS {
		log.errorf("Failed to reach target FPS: %i -> %i", TARGET_FPS, check_fps)
	}
}
