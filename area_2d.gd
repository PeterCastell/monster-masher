extends Area2D

var chase : bool = false;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		chase = true
		#print("Hi")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		chase = false
		#print("Bye")
	
