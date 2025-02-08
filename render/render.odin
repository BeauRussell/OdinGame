package render
import rl "vendor:raylib"
import "core:strings"
import "core:c"

import "../pkg"
import tracy "../odin-tracy"

Vec2 :: [2]f32

init :: proc(fps: i32) {
	tracy.Zone()
	pkg.init_settings()

	c_title := strings.clone_to_cstring(pkg.settings.window.title)
	defer delete(c_title)
	c_width := cast(c.int32_t)pkg.settings.window.width
	c_height := cast(c.int32_t)pkg.settings.window.height

    rl.InitWindow(c_width, c_height, c_title)
    rl.SetTargetFPS(fps)
	delete(pkg.settings.window.title)
}

shutdown :: proc() {
	tracy.Zone()
    rl.CloseWindow()
}

running :: proc() -> bool {
	tracy.Zone()
    return !rl.WindowShouldClose()
}

start_render :: proc() {
	tracy.Zone()
    rl.BeginDrawing()
	cam := rl.Camera2D { zoom = 32 }
	rl.BeginMode2D(cam)
    rl.ClearBackground(rl.RAYWHITE)
}

draw_player :: proc(position: Vec2) {
	tracy.Zone()
	rl.DrawRectangleRec({position.x, -position.y, 1, 2}, rl.DARKBLUE)
}
