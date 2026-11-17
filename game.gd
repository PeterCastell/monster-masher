extends Node
class_name Game
static var instance: Game

enum Parts {
	WEREWOLF_CLAWS,
	BAT,
	BROOM,
	NONE
}

@export var part_scenes: Dictionary[Parts, PackedScene]
@export var bottom_ui_hint : Label


func _enter_tree() -> void:
	instance = self
	
	
var world: World:
	get: return $World


var canvas: Canvas:
	get: return $UI/Canvas
	
var player: Player:
	get: return world.player

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
