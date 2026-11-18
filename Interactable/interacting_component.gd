extends Node2D

# note: is_interactable doesnt work

@onready var label: Label = $Label

var current_interactions : Array[Interactable] = []
var can_interact := true

func _input(event: InputEvent):
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions:
			can_interact = false
			label.hide()
			
			current_interactions[0].interacted.emit()
			#await current_interactions[0].
			
			can_interact = true
			
func _process(delta: float) -> void:
	var change_text = Game.instance.bottom_ui_hint.text != "Hold CTRL to reset"
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			#label.text = current_interactions[0].interact_name
			var postfix = ""
			if current_interactions[0].interact_group == "PART":
				if Game.instance.player.held_part !=null:
					postfix = " swap"
				else:
					postfix = " pick up"
			if current_interactions[0].interact_group == "LEVER":
					postfix = " pull"
			label.text = "E" + postfix
			label.show() 
			if (change_text):
				Game.instance.bottom_ui_hint.text = "Press E to" + postfix
		else:
			label.hide()
			if (change_text):
				Game.instance.bottom_ui_hint.text = ""
	else:
		label.hide()
		if (change_text):
				Game.instance.bottom_ui_hint.text = ""
			
func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
	
	
func _on_interact_range_area_entered(area: Area2D) -> void:
	current_interactions.push_back(area)


func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)
