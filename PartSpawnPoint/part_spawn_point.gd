extends Node2D
class_name PartSpawner

@export var part_type : Game.Parts

@onready var game: Game = $/root/Game

var spawnedPart : Part


func _ready() -> void:
	spawnPart.call_deferred()

func spawnPart():
	var part = game.instance.part_scenes[part_type].instantiate()
	part.global_position = $SpawnLocation.global_position

	game.instance.world.parts.add_child(part)

	
	
	spawnedPart = part

func reset():
	if spawnedPart != null:
		spawnedPart.queue_free()
	spawnPart()
