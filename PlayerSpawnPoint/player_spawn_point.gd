extends Node2D

class_name PlayerSpawnPoint

func spawnPlayer() -> void:
	Game.instance.player.global_position = $SpawnLocation.global_position
	
