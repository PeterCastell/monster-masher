extends Node2D
class_name PlayerExit

signal exited

func _on_interactable_interacted() -> void:
	exited.emit()
