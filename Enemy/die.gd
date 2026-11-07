extends Node

class_name Die
const ORGAN = preload("uid://bm5vvxaeo3lq5")
@onready var organs_folder: Node = $"../../../../OrgansFolder"


func die():
	print("die")
	var organ = ORGAN.instantiate()	
	organs_folder.add_child(organ)
	organ.global_position = get_parent().global_position
	
	get_parent().get_parent().queue_free()
