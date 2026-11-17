extends Node2D

class_name Activator


@export var starting_state : bool = false

var is_on : bool = false

@export var duration : float = 1

func activate() -> void:
	print("abstract")
