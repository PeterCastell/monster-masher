extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic


func _ready() -> void:
	menu_music.play()

# on play pressed
func _on_button_pressed() -> void:
	$ThunderClap.play()
	menu_music.stop()
	$ScaryCastle.play()
	pass # Replace with function body.
