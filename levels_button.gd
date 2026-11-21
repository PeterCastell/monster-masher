extends TextureButton

@onready var color_rect: ColorRect = $"../ColorRect"


func _on_pressed() -> void:
	color_rect.visible = true
