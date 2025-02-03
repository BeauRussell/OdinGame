package engine

import "core:log"

import b2 "vendor:box2d"
import rl "vendor:raylib"

world_id: b2.WorldId
player_id: b2.BodyId

init_world :: proc() -> b2.WorldId {
	world_def := b2.DefaultWorldDef()
	world_def.gravity = b2.Vec2{0, -10}
	world_id = b2.CreateWorld(world_def)

	return world_id
}

destroy_world :: proc(id: b2.WorldId = world_id) {
	b2.DestroyWorld(id)
}

create_ground_body :: proc(ground: Box) -> b2.BodyId {
	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{ground.x, -ground.y-ground.height}
	ground_body_id := b2.CreateBody(world_id, ground_body_def)

	ground_box := b2.MakeBox(ground.width, ground.height)
	ground_shape_def := b2.DefaultShapeDef()
	_ = b2.CreatePolygonShape(ground_body_id, ground_shape_def, ground_box)

	return ground_body_id
}

create_player :: proc() -> b2.BodyId {
	body_def := b2.DefaultBodyDef()
	body_def.type = .dynamicBody
	body_def.position = b2.Vec2{1, -1}
	body_def.fixedRotation = true
	log.info(body_def)
	player_id = b2.CreateBody(world_id, body_def)

	box := b2.MakeBox(1,2)
	box_def := b2.DefaultShapeDef()
	box_def.density = 1
	box_def.friction = 0.3
	_ = b2.CreatePolygonShape(player_id, box_def, box)

	return player_id
}

step_world :: proc(time_step: f32, sub_step: i32) -> Vec2 {
	b2.World_Step(world_id, time_step, sub_step)
	log.info(b2.Body_GetPosition(player_id))
	return b2.Body_GetPosition(player_id)
}
