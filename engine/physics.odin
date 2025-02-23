package engine

import "core:log"

import b2 "vendor:box2d"

world_id: b2.WorldId
player_id: b2.BodyId
player_data: User_Data

WORLD_GRAVITY :: b2.Vec2{0, -20}
MAX_VELOCITY_SIDE :: b2.Vec2{20, 0}
JUMP_FORCE :: b2.Vec2{0, 25}

init_world :: proc() -> b2.WorldId {
	world_def := b2.DefaultWorldDef()
	world_def.enableSleep = false
	world_def.gravity = WORLD_GRAVITY
	world_id = b2.CreateWorld(world_def)

	return world_id
}

destroy_world :: proc(id: b2.WorldId = world_id) {
	b2.DestroyWorld(id)
}

create_ground_body :: proc(ground: Box) {
	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{ground.x, -ground.y}
	ground_body_id := b2.CreateBody(world_id, ground_body_def)

	ground_box := b2.MakeBox(ground.width, ground.height)
	ground_shape_def := b2.DefaultShapeDef()
	ground_shape_def.friction = 0.4 
	_ = b2.CreatePolygonShape(ground_body_id, ground_shape_def, ground_box)
}

create_player :: proc() {
	body_def := b2.DefaultBodyDef()
	body_def.type = .dynamicBody
	body_def.position = b2.Vec2{1, -28}
	body_def.fixedRotation = true
	body_def.linearDamping = 0 
	body_def.userData = &player_data
	player_id = b2.CreateBody(world_id, body_def)

	capsule := b2.Capsule {
		center1 = {0.5, 0.5},
		center2 = {0.5, 1.5},
		radius = 0.5,
	}
	capsule_def := b2.DefaultShapeDef()
	capsule_def.friction = 0.2 
	_ = b2.CreateCapsuleShape(player_id, capsule_def, capsule)
}

step_world :: proc(time_step: f32, sub_step: i32) -> Vec2 {
	b2.World_Step(world_id, time_step, sub_step)
	user_data := b2.Body_GetUserData(player_id)
	return b2.Body_GetPosition(player_id)
}

move_player :: proc(direction: Move_Options) {
	if player_data.state == .Jumping {
		return
	}
	switch direction {
	case .Right: 
		move_consistent_speed(MAX_VELOCITY_SIDE, player_id)
	case .Left:
		move_consistent_speed(MAX_VELOCITY_SIDE * -1, player_id)
	case .Jump:
		b2.Body_ApplyLinearImpulseToCenter(player_id, JUMP_FORCE, true)
	}
}

move_consistent_speed :: proc(max: Vec2, player_id: b2.BodyId) {
	force := calculate_force_for_constant_speed(max, player_id)
	b2.Body_ApplyForceToCenter(player_id, force, true)
}

calculate_force_for_constant_speed :: proc(maxVelocity: Vec2, bodyId: b2.BodyId) -> Vec2 {
	force: Vec2
	currentVel := b2.Body_GetLinearVelocity(bodyId)
	mass := b2.Body_GetMass(bodyId)

	force.x = maxVelocity.x - currentVel.x
	force.y = maxVelocity.y - currentVel.y
	force = force * mass

	return force 
}

check_contacts :: proc() {
	player_contacts := b2.Body_GetContactCapacity(player_id)
	if player_contacts == 0 {
		player_data.state = .Jumping
	} else {
		player_data.state = .Idle
	}
}

create_moveable_box :: proc(pos: Vec2) -> b2.BodyId {
	box_body_def := b2.DefaultBodyDef()
	box_body_def.position = pos 
	box_body_def.type = .dynamicBody
	box_body_id := b2.CreateBody(world_id, box_body_def)

	box_shape := b2.MakeSquare(1)
	box_shape_def := b2.DefaultShapeDef()
	box_shape_def.friction = 0.2 
	_ = b2.CreatePolygonShape(box_body_id, box_shape_def, box_shape)

	return box_body_id
}
