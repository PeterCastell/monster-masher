extends Control

var can_view_operation_screen = true
var operation_toggled = false

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and can_view_operation_screen:
		if !get_tree().paused:
			get_tree().paused = true
			$PauseAnimationPlayer.play("pause")
		else:
			get_tree().paused = false
			$PauseAnimationPlayer.play("unpause")
