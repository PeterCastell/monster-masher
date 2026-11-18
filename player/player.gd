extends CharacterBody2D
class_name Player

var held_part : Part = null

const gravity = 1300
const jump_speed = 650
const max_speed = 500
const ground_accel_hl = 0.2
const air_accel_hl = 0.5
const air_friction_hl = 1
const ground_friction_hl = 0.3
const wall_friction_hl = 0.1
const enemy_kill_range = 35
const enemy_kill_jump = -300
const enemy_above_jump = -100


var can_wall_jump: bool = false
var can_flutter: bool = false
var can_dash: bool = false


const flutter_descent_speed = 100

const coyote_duration = 0.2
var left_wall_jump_coyote_time: float = 0
var right_wall_jump_coyote_time: float = 0
var jump_coyote_time: float = 0

const jump_buffer_duration = 0.15
var jump_buffer_time: float = 0

#signal death


#var double_space_time = 0.0
#const double_space_duration = 0.2
const dash_speed: float = 900
var dash_time: float = -1
var dash_lock_y_time: float = -1
var dash_lock_y_dur: float = 0.1
const dash_duration: float = 1.2

var animation: String:
	get: return $AnimatedSprite2D.animation
	set(v): $AnimatedSprite2D.animation = v

func drop_item():
	if (held_part != null):
		held_part.drop_from_player($SpawnPartLocation.global_position)

func reset():
	velocity = Vector2.ZERO
	if held_part != null:
		var temp = held_part
		held_part.drop_from_player(Vector2.ZERO)
		temp.queue_free()
		held_part = null

func spawn_part_from_player():
	#var part = Game.instance.part_scenes[held_part].instantiate()
	#Game.instance.world.parts.add_child(part)
	#part.global_position = $SpawnPartLocation.global_position
	#spawnedPart = part	
	pass
	
func _physics_process(delta: float) -> void:
	
	if((held_part != null) and is_on_floor() and Input.is_action_pressed("drop_item")):
		drop_item()
		
	# dont use gravity when dashing
	if not is_on_floor() and dash_lock_y_time < 0:
		velocity += Vector2.DOWN * gravity * delta
	
	var anim: String = ""
	
	var input := Input.get_axis("left", "right")
	if (dash_lock_y_time > 0):
		anim = "dash"
		input = 0
		
	if input:
		$AnimatedSprite2D.scale.x = sign(input)  # dash depends on the direction of this
	
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
	
	if Input.is_action_just_pressed("dash") and can_dash and dash_time < 0:
		velocity.x = dash_speed * sign($AnimatedSprite2D.scale.x)
		velocity.y = 0
		dash_time = dash_duration
		dash_lock_y_time = dash_lock_y_dur
	else: 
		dash_time -= delta
		dash_lock_y_time -= delta
		
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
		anim = "claws_slide"
	
	# accelerate x from input
	velocity.x = util.hllerp(velocity.x, input * max_speed, (ground_accel_hl if is_on_floor() else air_accel_hl), delta)
	
	if can_flutter && Input.is_action_pressed("up"):
		anim = "flutter"
		velocity.y = min(velocity.y, flutter_descent_speed)
	
	move_and_slide()
	
	if position.y > 1000:
		kill()
	
	if not is_on_floor() and anim == "":
		anim = "up" if velocity.y < 0 else "down"
	
	if anim == "":
		anim = "running" if input != 0 else "idle"
	animation = anim


func kill() -> void:
	Game.instance.restart_level()
