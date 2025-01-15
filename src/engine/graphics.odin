package engine

import "vendor:raylib"
import "../pkg"
import "core:strings"
import "core:c"

init :: proc() {
	pkg.init_settings()

	c_title := strings.clone_to_cstring(pkg.settings.window.title)
	c_width := cast(c.int32_t)pkg.settings.window.width
	c_height := cast(c.int32_t)pkg.settings.window.height

    raylib.InitWindow(c_width, c_height, c_title)
    raylib.SetTargetFPS(60)
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

	raylib.DrawRectangle(0,0, 100, 100, raylib.DARKBLUE)
}
