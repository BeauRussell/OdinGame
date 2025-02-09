package engine

import "core:log"

import b2 "vendor:box2d"
import rl "vendor:raylib"

import tracy "../odin-tracy"

world_id: b2.WorldId
player_id: b2.BodyId

WORLD_GRAVITY :: b2.Vec2{0, -20}
MAX_VELOCITY_SIDE :: b2.Vec2{40, 0}

init_world :: proc() -> b2.WorldId {
	tracy.Zone()
	world_def := b2.DefaultWorldDef()
	world_def.enableSleep = false
	world_def.gravity = WORLD_GRAVITY
	world_id = b2.CreateWorld(world_def)

	return world_id
}

destroy_world :: proc(id: b2.WorldId = world_id) {
	tracy.Zone()
	b2.DestroyWorld(id)
}

create_ground_body :: proc(ground: Box) {
	tracy.Zone()
	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{ground.x, -ground.y}
	ground_body_id := b2.CreateBody(world_id, ground_body_def)

	ground_box := b2.MakeBox(ground.width, ground.height)
	ground_shape_def := b2.DefaultShapeDef()
	ground_shape_def.friction = 1 
	_ = b2.CreatePolygonShape(ground_body_id, ground_shape_def, ground_box)
}

create_player :: proc() {
	tracy.Zone()
	body_def := b2.DefaultBodyDef()
	body_def.type = .dynamicBody
	body_def.position = b2.Vec2{1, -28}
	body_def.fixedRotation = true
	body_def.linearDamping = 1
	player_id = b2.CreateBody(world_id, body_def)

	capsule := b2.Capsule {
		center1 = {0.5, 0.5},
		center2 = {0.5, 1.5},
		radius = 0.5,
	}
	capsule_def := b2.DefaultShapeDef()
	capsule_def.friction = 1
	_ = b2.CreateCapsuleShape(player_id, capsule_def, capsule)
}

step_world :: proc(time_step: f32, sub_step: i32) -> Vec2 {
	tracy.Zone()
	b2.World_Step(world_id, time_step, sub_step)
	return b2.Body_GetPosition(player_id)
}

move_player :: proc(direction: Move_Direction) {
	tracy.Zone()
	max: Vec2
	if direction == .Left {
		max = MAX_VELOCITY_SIDE * -1
	} else if direction == .Right {
		max = MAX_VELOCITY_SIDE
	}
	force := calculate_force_for_constant_speed(max, player_id)
	b2.Body_ApplyForceToCenter(player_id, force, true)
}

calculate_force_for_constant_speed :: proc(maxVelocity: Vec2, bodyId: b2.BodyId) -> Vec2 {
	tracy.Zone()
	force: Vec2
	currentVel := b2.Body_GetLinearVelocity(bodyId)
	mass := b2.Body_GetMass(bodyId)

	force.x = maxVelocity.x - currentVel.x
	force.y = maxVelocity.y - currentVel.y
	force = force * mass

	return force 
}
