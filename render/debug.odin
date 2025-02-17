package render

import b2 "vendor:box2d"
import rl "vendor:raylib"

DEBUG_DRAW: b2.DebugDraw = {
	DrawSolidCapsule = draw_capsule,
	DrawSolidPolygon = draw_polygon,
	drawShapes = true,
}

draw_capsule :: proc "c" (p1, p2: [2]f32, radius: f32, color: b2.HexColor, ctx: rawptr) {
	rl.DrawCapsule({p1.x, -p1.y, 0}, {p2.x, -p2.y, 0}, radius, 10, 10, rl.GetColor(cast(u32)color))
}

draw_polygon :: proc "c" (transform: b2.Transform, vertices: [^][2]f32, vertexCount: i32, radius: f32, color: b2.HexColor, ctx: rawptr) {
	//Must implement any procedure callback that will be called
}
