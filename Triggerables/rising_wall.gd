extends Triggerable

@export var target : Vector2 = Vector2(0, -300)
@export var start_point : Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func rise(is_on: bool, duration:float):
	print("rise")
	duration = 1
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if (is_on):
	#tween.parallel(true)
		tween.tween_property(self, "position", target ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	else: 
		tween.tween_property(self, "position", start_point ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
func reset():
	pass

func _on_lever_flipped(is_on: bool, duration: float) -> void:
	rise(is_on, duration)
