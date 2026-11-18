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

@export var levels: Array[PackedScene]

var level: Level = null
var level_index: int = 0

# to handle ctrl to reset puzzle
var ctrl_time : float = 0
const ctrl_target : float = 1

func _init() -> void:
	instance = self

var world: World:
	get: return $World

var canvas: Canvas:
	get: return $UI/Canvas
	
var player: Player:
	get: return world.player

func _process(delta):
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("reset"):
		ctrl_time += delta
	else:
		ctrl_time = 0
	if ctrl_time > ctrl_target:
		ctrl_time = 0
		restart_level()


func restart_level() -> void:
	enter_level(level_index)
	bottom_ui_hint.text = ""

func next_level() -> void:
	if level_index+1 >= len(levels):
		return # TODO return to title
	enter_level(level_index + 1)

func enter_level(index: int) -> void:
	bottom_ui_hint.text = ""
	player.reset()
	for item in world.parts.get_children():
		item.queue_free()
	if level != null:
		level.queue_free()
	
	level = levels[index].instantiate()
	$World/Level.add_child(level)
	level_index = index
