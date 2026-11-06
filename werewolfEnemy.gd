extends CharacterBody2D

const wind_up_time: float = 0.5
const max_speed = 450
const walk_speed = 50

const ground_accel_hl = 0.8
const wall_detect_offset = 32

@onready var collision_shape = $CollisionShape2D
@onready var player: Player = $"../../Player"

# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

# This enum lists all the possible states the character can be in.
enum States {IDLE, CHARGING, CHASING, REWINDING}

var state: States = States.IDLE: set = set_state

# We have two different gravity values, one for the character on the ground and one for when gliding.
var base_gravity := 4000.0
var glide_gravity := 400.0
# This is the current gravity, which is applied to the character every frame.
var current_gravity := base_gravity

var dir: float = 1

func _physics_process(delta: float) -> void:
	$Appearance/EnemySprite.modulate = Color.WHITE
	
	if state == States.CHASING:
		# walk
		velocity.x = util.hllerp(velocity.x, dir * max_speed, ground_accel_hl, delta)
		move_and_slide()		
	
	elif state == States.IDLE:	
		var space_state = get_world_2d().direct_space_state
		# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
		# my first time doing this in Godot 
		var wallAhead = PhysicsRayQueryParameters2D.create(
			Vector2(global_position.x, global_position.y),
			Vector2(global_position.x + (((collision_shape.shape.size.x/2) + wall_detect_offset)*dir), global_position.y)
		)
		
		var wallBelow = PhysicsRayQueryParameters2D.create(
			Vector2(global_position.x, global_position.y),
			Vector2(global_position.x + (collision_shape.shape.size.x)*dir, global_position.y + (collision_shape.shape.size.y))
		)
		
		var result = space_state.intersect_ray(wallAhead) or not space_state.intersect_ray(wallBelow)

		if (result):
			dir *= -1
		# walk	
		velocity.x = dir * walk_speed
	
		move_and_slide()		
		
		if $Area2D.chase: 
			set_state(States.CHARGING)
		
	elif state == States.CHARGING:	
		dir = sign(player.global_position.x - global_position.x)
		# temp
		$Appearance/EnemySprite.modulate = Color.RED
		if ($ChargeTimer.is_stopped()):
			set_state(States.CHASING)	
	
	$Appearance.scale.x = dir
	

func set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state

	if previous_state == States.IDLE:
		$ChargeTimer.start(wind_up_time)
