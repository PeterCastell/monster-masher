extends Node2D

class_name Room

@export var spawns : Array[PlayerSpawnPoint] 

@export var start_spawn : PlayerSpawnPoint

var current_spawn : PlayerSpawnPoint
var index = 0

func _ready() -> void:
	if spawns.is_empty():
		spawns.assign($PlayerSpawnPoints.get_children())
	if start_spawn == null:
		start_spawn = spawns[0]
	current_spawn = start_spawn
	print("assigned room")
	
func enter_room():
	print("entering " + self.name)
	current_spawn.spawnPlayer()

func reset():
	for tween in get_tree().get_processed_tweens():
		tween.kill()
	Game.instance.player.drop_item()
	for child in $PartSpawnPoints.get_children():
		child.reset()
	for child in $Activators.get_children():
		child.reset()
	
	Game.instance.bottom_ui_hint.text = ""

	# activators reset triggerables actually ok
	#for child in $Triggerables.get_children():
		#child.reset()
	
	# to do, reset hold stats
	enter_room()



func changeSpawn(spawn_point: PlayerSpawnPoint) -> bool:
	index = spawns.find(spawn_point)
	if index == -1:
		printerr("spawn point error")
		return false
	current_spawn = spawn_point
	
	return true

func changeSpawnByIndex(spawn_index: int) -> bool:
	if(spawn_index < 0 or spawn_index >= spawns.size()):
		printerr("index error")
		return false
	current_spawn = spawns[spawn_index]
	index = spawn_index
	return true

func setNextPlayerSpawnPoint() -> bool:
	return changeSpawnByIndex(index + 1)
