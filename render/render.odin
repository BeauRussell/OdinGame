package render
import "vendor:raylib"
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

    raylib.InitWindow(c_width, c_height, c_title)
    raylib.SetTargetFPS(fps)
	delete(pkg.settings.window.title)
}

shutdown :: proc() {
    raylib.CloseWindow()
}

running :: proc() -> bool {
    return !raylib.WindowShouldClose()
}

render :: proc() {
    raylib.BeginDrawing()
    defer raylib.EndDrawing()

    raylib.ClearBackground(raylib.RAYWHITE)
}

draw_player :: proc(position: Vec2) {
	raylib.DrawRectanglePro({position.x, -position.y, 40, 40}, {20, 20}, 0, raylib.DARKBLUE)
}
