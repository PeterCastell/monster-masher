extends CharacterBody2D
class_name Player

const gravity = 1200
const jump_speed = 650
const max_speed = 450
const ground_accel_hl = 0.2
const air_accel_hl = 0.5
const air_friction_hl = 1
const ground_friction_hl = 0.3
const wall_friction_hl = 0.1

var can_wall_jump: bool = true
var can_flutter: bool = true

const flutter_descent_speed = 100

const coyote_duration = 0.2
var left_wall_jump_coyote_time: float = 0
var right_wall_jump_coyote_time: float = 0
var jump_coyote_time: float = 0

const jump_buffer_duration = 0.15
var jump_buffer_time: float = 0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += Vector2.DOWN * gravity * delta
	
	var input := Input.get_axis("left", "right")
	
	if input:
		$AnimatedSprite2D.scale.x = sign(input)
	
	if can_wall_jump and input < 0 and len($WallJumpLeft.get_overlapping_bodies()) > 0:
		left_wall_jump_coyote_time = coyote_duration
	else:
		left_wall_jump_coyote_time -= delta
	
	if can_wall_jump and input > 0 and len($WallJumpRight.get_overlapping_bodies()) > 0:
		right_wall_jump_coyote_time = coyote_duration
	else:
		right_wall_jump_coyote_time -= delta
		
	if is_on_floor():
		jump_coyote_time = coyote_duration
	else:
		jump_coyote_time -= delta
	
	var wall_jump_eligible := left_wall_jump_coyote_time > 0 or right_wall_jump_coyote_time > 0
	
	if Input.is_action_just_pressed("up"):
		jump_buffer_time = jump_buffer_duration
	else:
		jump_buffer_time -= delta

	if jump_buffer_time > 0:
		if jump_coyote_time > 0:
			jump_buffer_time = 0
			jump_coyote_time = 0
			velocity.y = -jump_speed
		elif left_wall_jump_coyote_time > 0 and len($WallJumpLeft.get_overlapping_bodies()) > 0:
			jump_buffer_time = 0
			left_wall_jump_coyote_time = 0
			velocity = Vector2.UP.rotated(PI/4) * jump_speed
		elif right_wall_jump_coyote_time > 0 and len($WallJumpRight.get_overlapping_bodies()) > 0:
			jump_buffer_time = 0
			right_wall_jump_coyote_time = 0
			velocity = Vector2.UP.rotated(-PI/4) * jump_speed
	
	# slow down in all directions from friction
	if is_on_floor():
		if sign(input) != sign(velocity.x):
			velocity.x = util.hllerp(velocity.x, 0, ground_friction_hl, delta)
	else:
		velocity = util.hllerp(velocity, Vector2.ZERO, air_friction_hl, delta)
	
	# slow down y on walls
	if wall_jump_eligible and velocity.y > 0:
		velocity.y = util.hllerp(velocity.y, 0, wall_friction_hl, delta)
	
	# accelerate x from input
	velocity.x = util.hllerp(velocity.x, input * max_speed, (ground_accel_hl if is_on_floor() else air_accel_hl), delta)
	
	if can_flutter && Input.is_action_pressed("up"):
		velocity.y = min(velocity.y, flutter_descent_speed)
	
	move_and_slide()
	
	if position.y > 1000:
		position = Vector2.ZERO
