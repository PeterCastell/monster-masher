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
@onready var main_menu: Control = %MainMenu
@onready var time_label: Label = $UI/Canvas/TimeLabel

@export var levels: Array[PackedScene]

var level: Level = null
var level_index: int = 0
var is_speedrunning = false
static var won = false
static var win_time = "0:00"

# to handle ctrl to reset puzzle
var ctrl_time : float = 0
const ctrl_target : float = 1

var play_time: float = 0.0

func _init() -> void:
	instance = self

var world: World:
	get: return $World

var canvas: Canvas:
	get: return $UI/Canvas
	
var player: Player:
	get: return world.player

# claude
func format_time(seconds: float) -> String:
	var total := int(seconds)
	var h := total / 3600
	var m := (total % 3600) / 60
	var s := total % 60
	return "%02d:%02d:%02d" % [h, m, s]

func _process(delta):
	play_time += delta
	if Input.is_action_pressed("restart"):
		won = true
		win_time = format_time(play_time)
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
		get_tree().reload_current_scene()
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
