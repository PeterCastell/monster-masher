extends Part

class_name claws


func give_ability() -> void:
	Game.instance.player.can_wall_jump = true
func disable_ability() -> void:
	Game.instance.player.can_wall_jump = false

func get_type() ->  Game.Parts:
	return Game.Parts.WEREWOLF_CLAWS
