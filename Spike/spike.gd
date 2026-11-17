extends StaticBody2D

class_name Spike

@onready var area_2d: Area2D = $Area2D

func _physics_process(delta: float) -> void:
	for body in area_2d.get_overlapping_bodies():
		if body is Player:
			Game.instance.player.curr_room.reset()
		elif body is Part:
			body.kill()
