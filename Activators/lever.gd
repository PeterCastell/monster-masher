@tool
extends Activator
class_name Leverl
#func activate(on: bool) -> void:

signal flipped (is_on: bool, dur: float)

@onready var interactable: Interactable = $Interactable

@export_range(0, 4, 1) var icon: int = 0:
	get: return icon
	set(v):
		icon = v
		$Icon.index = icon


@export_tool_button("Snap") var snap_btn = func(): position = round(position / 64) * 64


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
	interactable.interact_group = "LEVER"
