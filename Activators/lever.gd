extends Activator

#func activate(on: bool) -> void:

signal flipped (is_on: bool, dur: float)

@export var starting_state : bool = true
@export var duration : float = 1

var is_on : bool = true

func activate() -> void:
	is_on = !is_on
	print("lever")
	var tween = create_tween()
	if is_on:
		tween.tween_property($LeverMovable, "rotation_degrees", 45, duration)
		#$AnimationPlayer.play("lever_on")
	else:
		tween.tween_property($LeverMovable, "rotation_degrees", -45, duration)
		
		#$AnimationPlayer.play("lever_off")
	
	emit_signal("flipped", is_on, duration)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = activate
	reset()


func reset():
	is_on = !starting_state
	activate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
