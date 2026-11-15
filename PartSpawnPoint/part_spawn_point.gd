extends Node2D
class_name PartSpawner

@export var part_type : Game.Parts

@onready var game: Game = $/root/Game

var spawnedPart : Part

# laggy but idc
func _ready() -> void:
	spawnPart()

func spawnPart():
	var part = game.instance.part_scenes[part_type].instantiate()

	game.instance.world.parts.add_child(part)

	
	part.global_position = $SpawnLocation.global_position
	
	spawnedPart = part

func reset():
	if spawnedPart != null:
		spawnedPart.queue_free()
	spawnPart()
