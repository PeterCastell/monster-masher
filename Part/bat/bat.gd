extends Part

class_name Bat


func give_ability() -> void:
	Game.instance.player.can_flutter = true
	
func disable_ability() -> void:
	Game.instance.player.can_flutter = false

func get_type() ->  Game.Parts:
	return Game.Parts.BAT
