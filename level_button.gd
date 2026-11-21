extends TextureButton
@onready var label: Label = $Label

var dest = 1


signal played 


func _on_pressed() -> void:
	get_tree().paused = false
	Game.instance.main_menu.visible = false
	Game.instance.enter_level(dest)
	emit_signal("played")
