extends Node

class_name Die
const CLAWS = preload("uid://bm5vvxaeo3lq5")
const BAT = preload("uid://dfnxongo8fr16")


@onready var organs_folder: Node = $"../../../../OrgansFolder"


func die():
	print("die")
	var info_component = get_parent().get_node_or_null("EnemyInfo")
	
	var organ = null
	if info_component.organ_type == Game.Organs.WEREWOLF_CLAWS:
		organ = CLAWS.instantiate()
	elif info_component.organ_type == Game.Organs.BAT:
		organ = BAT.instantiate()
		
	organs_folder.add_child(organ)
	organ.global_position = get_parent().global_position
	
	get_parent().get_parent().queue_free()
