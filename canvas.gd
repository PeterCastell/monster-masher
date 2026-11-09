extends CanvasLayer
class_name Canvas

var can_view_operation_screen = true
var operation_toggled = false



func _ready():
	# pause
	get_tree().paused = true
	
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and can_view_operation_screen:
		if $AnimationPlayer.is_playing():
			return
		if !operation_toggled:
			$AnimationPlayer.play("slide_down2")
			operation_toggled = true
		else:
			$AnimationPlayer.play_backwards("slide_down2")
			operation_toggled = false

func _on_play_button_pressed() -> void:
	# TODO
	get_tree().paused = false
	
	$MainMenu.visible = false
