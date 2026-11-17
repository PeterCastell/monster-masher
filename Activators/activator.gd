extends Node2D

class_name Activator


@export var starting_state : bool = false

var is_on : bool = false

@export var duration : float = 1

func activate() -> void:
	print("abstract")

func reset():
	print("RESET called")
	# bad code
	var real_duration = duration
	duration = 0
	is_on = !starting_state
	print("activate calling with ", is_on)
	activate()
	duration = real_duration
