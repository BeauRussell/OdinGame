package main

import "vendor:raylib"
import "core:fmt"

main :: proc() {
	raylib.InitWindow(1280, 720, "Game")
	raylib.SetTargetFPS(60)
	closeWindow := false
	for ; !closeWindow; {
		if raylib.WindowShouldClose() {
			closeWindow = true
		}
		raylib.BeginDrawing()
		{
			raylib.ClearBackground(raylib.RAYWHITE)
		}
		raylib.EndDrawing()
	}
	raylib.CloseWindow()
}
