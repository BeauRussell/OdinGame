package render

import "core:log"

import b2 "vendor:box2d"
import rl "vendor:raylib"

DEBUG_DRAW: b2.DebugDraw = {
	DrawCapsule = draw_capsule,
}

draw_capsule :: proc "c" (p1, p2: [2]f32, radius: f32, color: b2.HexColor, ctx: rawptr) {
	rl.DrawCapsule({p1.x, p1.y, 0}, {p2.x, p2.y, 0}, radius, 0, 0, rl.GetColor(cast(u32)color))
}
