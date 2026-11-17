extends Activator

#func activate(on: bool) -> void:

signal flipped (is_on: bool, dur: float)

@onready var interactable: Interactable = $Interactable

func activate() -> void:
	is_on = !is_on
	
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
	interactable.interacted.connect(activate)
