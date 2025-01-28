package render
import "vendor:raylib"
import "../pkg"
import "../engine"
import "core:strings"
import "core:c"

init :: proc() {
	pkg.init_settings()

	c_title := strings.clone_to_cstring(pkg.settings.window.title)
	defer delete(c_title)
	c_width := cast(c.int32_t)pkg.settings.window.width
	c_height := cast(c.int32_t)pkg.settings.window.height

    raylib.InitWindow(c_width, c_height, c_title)
    raylib.SetTargetFPS(60)
	delete(pkg.settings.window.title)
}

shutdown :: proc() {
    raylib.CloseWindow()
}

running :: proc() -> bool {
    return !raylib.WindowShouldClose()
}

render :: proc(character_pos: engine.EntityPosition) {
    raylib.BeginDrawing()
    defer raylib.EndDrawing()

    raylib.ClearBackground(raylib.RAYWHITE)
	draw_character(character_pos.x, character_pos.y)
}

draw_character :: proc(x, y: u16) {
	raylib.DrawRectangle(i32(x), i32(y), 20, 60, raylib.DARKBLUE)
}
