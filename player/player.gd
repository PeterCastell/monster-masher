extends CharacterBody2D
class_name Player

const gravity = 500
const jump_speed = 600
const max_speed = 300
const ground_accel_hl = 0.1
const air_accel_hl = 0.5
const air_friction_hl = 1
const ground_friction_hl = 0.1

var can_wall_jump: bool = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input := Input.get_axis("left", "right")
	
	if input:
		$AnimatedSprite2D.scale.x = sign(input)
	
	var wall_jump_eligible := can_wall_jump and is_on_wall() and input and velocity.y > 0
	
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			velocity.y = -jump_speed
		elif wall_jump_eligible:
			velocity = Vector2.UP.rotated(PI/4 * -sign(input)) * jump_speed
	
	# slow down in all directions from friction
	velocity = util.hllerp(velocity, Vector2.ZERO, ground_friction_hl if is_on_floor() or wall_jump_eligible else air_friction_hl, delta)
	
	# accelerate x from input
	velocity.x = util.hllerp(velocity.x, input * max_speed, (ground_accel_hl if is_on_floor() else air_accel_hl), delta)

	move_and_slide()
	print(velocity)
