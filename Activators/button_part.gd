extends Activator
var target : Vector2 = Vector2(0, 0)
var start_point : Vector2 = Vector2(0, 0)
signal pushed (is_on: bool, duration:float)


@onready var detector: Area2D = $AnimatableBody2D/Detector


func activate() -> void:
	is_on = !is_on
	print("button")
	var tween = create_tween()

	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if (is_on):
	#tween.parallel(true)
		tween.tween_property($AnimatableBody2D, "position", target ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	else: 
		tween.tween_property($AnimatableBody2D, "position", start_point ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	pushed.emit(is_on, duration)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var amount = detector.get_overlapping_bodies().size()
	if is_on and amount == 0 :
		activate()
	elif !is_on and amount > 0:
		activate()
	
	
	
