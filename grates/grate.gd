@tool
extends StaticBody2D
class_name Grate

@export_range(1, 99) var size: int = 1:
	get: return size
	set(v):
		size = v
		(func():
			$TextureRect.size.x = v * 64
			$CollisionShape2D.position.x = v * 32
			($CollisionShape2D.shape as RectangleShape2D).size.x = v * 64
		).call_deferred()

@export_tool_button("Snap") var snap_btn = func(): position = round(position / 64) * 64

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
