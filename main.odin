package main

import "base:runtime"
import "core:log"
import "core:mem"
import "core:prof/spall"
import "core:sync"

import b2 "vendor:box2d"
import rl "vendor:raylib"

import "engine"
import "pkg"
import "render"

TARGET_FPS : i32 : 60
SUB_STEPS: i32 : 4

spall_ctx: spall.Context
@(thread_local) spall_buffer: spall.Buffer

main :: proc() {
	context.logger = create_logger()
	defer log.destroy_console_logger(context.logger)

	when ODIN_DEBUG {
		spall_ctx = spall.context_create("profile.spall")
		defer spall.context_destroy(&spall_ctx)
		buffer_backing := make([]u8, spall.BUFFER_DEFAULT_SIZE)
		defer delete(buffer_backing)
		spall_buffer = spall.buffer_create(buffer_backing, u32(sync.current_thread_id()))
		defer spall.buffer_destroy(&spall_ctx, &spall_buffer)

		spall.SCOPED_EVENT(&spall_ctx, &spall_buffer, "main")

		b2.SetAssertFcn(box2_assert_handler)

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
		0, 34,
		60, 2 
	}

	engine.create_ground_body(ground)
	engine.create_player({1, -32})
	last_pos: engine.Vec2
	box_id := engine.create_moveable_box({10, -31})

	run := true
    for run {
		when ODIN_DEBUG {
			spall._buffer_begin(&spall_ctx, &spall_buffer, "frame", "")
			defer spall._buffer_end(&spall_ctx, &spall_buffer)
		}
		render.start_render()

		// TODO: Figure out what to do here instead of this
		ground_render := rl.Rectangle{ ground.x, ground.y - ground.height, ground.width, ground.height }

		rl.DrawRectangleRec(ground_render, rl.YELLOW)
		player_pos := engine.step_world(1.0 / f32(TARGET_FPS), SUB_STEPS)

		body_pos := b2.Body_GetPosition(box_id)

		rl.DrawRectangleV({body_pos.x - 1, -body_pos.y - 1}, {2, 2}, rl.GREEN)

		render.draw_player(player_pos)

		when ODIN_DEBUG {
			b2.World_Draw(world_id, &render.DEBUG_DRAW)
		}

		rl.EndMode2D()
		rl.EndDrawing()

		run = render.running()

		engine.check_contacts()
		engine.check_move_input()
		defer check_fps()
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

check_fps :: proc() {
	if check_fps := rl.GetFPS(); check_fps < TARGET_FPS {
		log.errorf("Failed to reach target FPS: %i -> %i", TARGET_FPS, check_fps)
	}
}

@(instrumentation_enter)
spall_enter :: proc "contextless" (proc_address, call_site_return_address: rawptr, loc: runtime.Source_Code_Location) {
	spall._buffer_begin(&spall_ctx, &spall_buffer, "", "", loc)
}

@(instrumentation_exit)
spall_exit :: proc "contextless" (proc_address, call_site_return_address: rawptr, loc: runtime.Source_Code_Location) {
	spall._buffer_end(&spall_ctx, &spall_buffer)
}

box2_assert_handler :: proc "c" (condition, file_name: cstring, line_number: i32) -> i32 {
	context = runtime.default_context()
	log.errorf("Box2d hit an assertion: condition %s at %s:%d", condition, file_name, line_number)
	return 0 
}
