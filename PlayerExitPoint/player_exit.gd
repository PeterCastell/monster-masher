extends Node2D

@export var next_room : Room
@onready var interactable: Area2D = $Interactable

func go_to_next_room():
	Game.instance.player.drop_item()
	next_room.enter_room()


func _ready() -> void:
	interactable.interact = go_to_next_room
	
