extends Enemy
class_name Vampire

var spd = 100
var dir = 1
var time = 0.0
var frequency = 5
var amplitude = 50
var start_y: float

var left_limit: float
var right_limit: float


func _ready():
	start_y = global_position.y
	left_limit = $LeftLimit.global_position.x
	right_limit = $RightLimit.global_position.x

func _physics_process(delta: float) -> void:
	if global_position.x < left_limit:
		dir = 1
	if global_position.x > right_limit:
		dir = -1
	
	time += delta

	velocity.x = spd * dir

	var target_y = start_y + sin(time * frequency) * amplitude

	global_position.y = move_toward(global_position.y, target_y, spd * delta)
	
	$Appearance.scale.x = dir
	move_and_slide()
