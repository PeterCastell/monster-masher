extends Node
class_name Game

enum Organs {
	WEREWOLF_CLAWS,
	BAT,
}

@export var organ_scenes: Dictionary[Organs, PackedScene]

var world: World:
	get: return $World

var player: Player:
	get: return world.player

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
