extends TextureButton
@onready var color_rect: ColorRect = $".."


func _on_pressed() -> void:
	color_rect.visible = false
