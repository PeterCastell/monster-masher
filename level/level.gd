extends Node
class_name Level

@export var spawn : PlayerSpawnPoint
@export var exit : PlayerExit

func _ready() -> void:
	Game.instance.player.reset()
	Game.instance.player.global_position = spawn.spawn_location
	
	exit.exited.connect(func(): Game.instance.next_level())
