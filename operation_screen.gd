extends Control
class_name OperationScreen

var operation_toggled := false

const offset = Vector2(100, -200)

@onready var player = $/root/Game.player

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_S):
		if $AnimationPlayer.is_playing():
			return
		if !operation_toggled:
			$AnimationPlayer.play("fade_in")
			operation_toggled = true
		else:
			$AnimationPlayer.play_backwards("fade_in")
			operation_toggled = false

	position = player.position + offset
	
