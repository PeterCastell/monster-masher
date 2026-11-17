extends Triggerable

@export var target : Vector2 = Vector2(0, -300)
@export var start_point : Vector2 = Vector2(0, 0)
@export var duration_override : int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatableBody2D/CollisionShape2D.shape = $AnimatableBody2D/CollisionShape2D.shape.duplicate()




func rise(is_on: bool, duration:float):
	print("rise")
	if(duration_override != -1 and duration != 0):
		duration = duration_override
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if (is_on):
	#tween.parallel(true)
		tween.tween_property($AnimatableBody2D, "position", target ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	else: 
		tween.tween_property($AnimatableBody2D, "position", start_point ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		

func _on_lever_flipped(is_on: bool, duration: float) -> void:
	rise(is_on, duration)


func _on_button_part_pushed(is_on: bool, duration: float) -> void:
	rise(is_on, duration)
