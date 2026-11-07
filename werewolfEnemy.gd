extends CharacterBody2D

const gravity = 1200
const player_kick_force = 800
const wind_up_time: float = 1
const rewind_time: float = 1.5

const max_speed = 450
const walk_speed = 50

const ground_accel_hl = 0.8
const wall_detect_offset = 32

@onready var collision_shape = $CollisionShape2D
@onready var player: Player = $"../../../Player"


# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

# This enum lists all the possible states the character can be in.
enum States {IDLE, CHARGING, CHASING, REWINDING}

var state: States = States.IDLE: set = set_state



var dir: float = 1


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector2.DOWN * gravity * delta
		move_and_slide()
		
		
	
	$Appearance/EnemySprite.modulate = Color.WHITE
	
	if state == States.CHASING:
		# walk
		#velocity.x = util.hllerp(velocity.x, dir * max_speed, ground_accel_hl, delta)
		# https://forum.godotengine.org/t/how-to-make-a-character2d-bounce-reflect-off-of-stuff/70523/6
		var collision = move_and_collide(Vector2(util.hllerp(velocity.x, dir * max_speed, ground_accel_hl, delta), velocity.y))		
		if collision:
			if collision.get_collider().is_in_group("Player"):
				player.velocity.x = player_kick_force * dir
			velocity = velocity.bounce(collision.get_normal())
			set_state(States.REWINDING)
	elif state == States.IDLE:	
		if is_on_floor():
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
		if dir == 0:
			dir = 1
		
		# temp
		$Appearance/EnemySprite.modulate = Color.RED
		if ($ChargeTimer.is_stopped()):
			set_state(States.CHASING)	
	
	elif state == States.REWINDING:
		$Appearance/EnemySprite.modulate = Color.BLUE
		velocity.x = util.hllerp(velocity.x, -dir * max_speed, -ground_accel_hl, delta)
		move_and_slide()		
		if ($RewindTimer.is_stopped()):
			set_state(States.IDLE)

		
	
	$Appearance.scale.x = dir
	

func set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state

	if new_state == States.CHARGING:
		$ChargeTimer.start(wind_up_time)
	
	if new_state == States.REWINDING:
		$RewindTimer.start(rewind_time)
		
