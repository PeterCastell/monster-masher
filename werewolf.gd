extends Enemy
class_name Werewolf

const gravity = 1200
const player_kick_force = 800
const minimal_player_kick_force = 300

const wander_speed = 50
const wander_speed_hl = 0.25
const dash_speed = 450
const dash_speed_hl = 0.5
const dash_bounciness = 0.25

@onready var collision_shape = $CollisionShape2D
@onready var player: Player = game.world.player

var timer: float

# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

# This enum lists all the possible states the character can be in.
enum State {
	Wandering,
	Windup,
	Dashing,
	Stunned
}

var state: State = State.Wandering

var dir: int = 1 if randf() < 0.5 else -1

var dir_to_player: int:
	get: return sign(player.position.x - position.x)

func on_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	
	var is_wall: bool = abs(collision.get_angle() - PI/2) < PI/4
	var is_floor: bool = PI - collision.get_angle() < PI/4

	if collider is Player and can_squish_player and is_floor:
		pass # TODO: kill the player

	if state == State.Dashing:
		if collider is Player:
			collider.velocity.x += player_kick_force*dir_to_player
			set_state(State.Stunned)
		elif collider is TileMapLayer:
			var normal := collision.get_normal()
			if is_wall:
				set_state(State.Stunned)
				dir *= -1
				velocity = velocity.slide(normal) - dash_bounciness * velocity.project(normal)
				return true
	
	else:
		if collider is Player:
			collider.velocity.x += minimal_player_kick_force*dir_to_player
		elif is_wall:
			dir *= -1
	
	velocity = velocity.slide(collision.get_normal())

func _physics_process(delta: float) -> void:
	velocity += Vector2.DOWN * gravity * delta
	
	$Appearance.scale.x = dir
	$Appearance/EnemySprite.modulate = Color.WHITE
	
	if state == State.Dashing:
		velocity.x = util.hllerp(velocity.x, 0, dash_speed_hl, delta)
		if abs(velocity.x) <= wander_speed:
			set_state(State.Wandering)
	
	elif state == State.Wandering:
		var foot: RayCast2D = $LeftFoot if dir == -1 else $RightFoot
		if !foot.is_colliding():
			dir *= -1
		
		velocity.x = util.hllerp(velocity.x, dir * wander_speed, wander_speed_hl, delta)
		
		for body in $Vision.get_overlapping_bodies():
			if body is Player and state == State.Wandering:
				set_state(State.Windup)
		
	elif state == State.Windup:
		velocity.x = util.hllerp(velocity.x, 0, wander_speed_hl, delta)
		$Appearance/EnemySprite.modulate = Color.RED
	
	elif state == State.Stunned:
		velocity.x = util.hllerp(velocity.x, 0, wander_speed_hl, delta)
		$Appearance/EnemySprite.modulate = Color.BLUE
	
	var motion := velocity * delta
	for i in 4:
		var collision := move_and_collide(motion)
		if not collision:
			break
		on_collision(collision)
		motion = velocity * delta
	
	$Appearance.scale.x = dir
	

func set_state(new_state: State) -> void:
	#var previous_state := state
	state = new_state

	if new_state == State.Windup:
		dir = dir_to_player
		$WindupTimer.start()
	
	if new_state == State.Stunned:
		$StunTimer.start()
		
	if new_state == State.Dashing:
		velocity.x = dir * dash_speed


func _on_windup_timer_timeout() -> void:
	set_state(State.Dashing)


func _on_stun_timer_timeout() -> void:
	set_state(State.Wandering)
