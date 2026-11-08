extends Node2D
class_name World


var organs: Node:
	get: return $Organs
	
var player: Player:
	get: return $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
