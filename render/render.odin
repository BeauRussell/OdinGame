package render
import rl "vendor:raylib"
import "../pkg"
import "../engine"
import "core:strings"
import "core:c"

Vec2 :: [2]f32

init :: proc(fps: i32) {
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
    rl.CloseWindow()
}

running :: proc() -> bool {
    return !rl.WindowShouldClose()
}

start_render :: proc() {
    rl.BeginDrawing()
	cam := rl.Camera2D { zoom = 32 }
	rl.BeginMode2D(cam)
    rl.ClearBackground(rl.RAYWHITE)
}

end_render :: proc() {
	rl.EndMode2D()
	rl.EndDrawing()
}

draw_player :: proc(position: Vec2) {
	rl.DrawRectangleRec({position.x, -position.y, 1, 2}, rl.DARKBLUE)
}
