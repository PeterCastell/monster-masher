extends CharacterBody2D
class_name Enemy

@export var can_squish : bool
@export var launch_back_force : float
@export var organ_type : Game.Organs

@onready var game: Game = $/root/Game

func die():
	print("die")
	
	var organ = game.organ_scenes[organ_type].instantiate()
	
	game.world.organs.add_child(organ)
	organ.global_position = global_position
	
	queue_free()
