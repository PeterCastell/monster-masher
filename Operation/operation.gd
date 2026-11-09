extends Node2D
class_name Operation

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# wolf
func _on_check_button_toggled(toggled_on: bool) -> void:
	print("wolf")
	player.can_wall_jump = toggled_on	


# wamp
func _on_check_vamp_toggled(toggled_on: bool) -> void:
	print("vamp")
	player.can_flutter = toggled_on	
