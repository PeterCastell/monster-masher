extends AnimatableBody2D

# DONT FIX THIS
# i wwant to learn how to make moving platform myself

@export var is_linear : bool = true
@export var spd : float = 100
@export var max_spd : float = 200

@export var left_target : Vector2 = Vector2(-100, 0)
@export var right_target : Vector2 = Vector2(100, 0)

var target : Vector2 


func _ready():
	left_target = position + left_target
	right_target = position + right_target
	target = left_target
	
func _physics_process(delta: float) -> void:
	var distance = position.distance_to(target)
	
	if is_linear:
		position = position.move_toward(target, spd * delta)

	else:
		
		var speed = min(max_spd, distance * 3)
		position = position.move_toward(target, speed * delta)

		
	if (distance < 1):
		target = left_target if (target == right_target) else right_target
	
