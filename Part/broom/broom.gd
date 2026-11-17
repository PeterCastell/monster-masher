extends Part

class_name Broom


func give_ability() -> void:
	Game.instance.player.can_dash = true
	
func disable_ability() -> void:
	Game.instance.player.can_dash = false

func get_type() ->  Game.Parts:
	return Game.Parts.BROOM
