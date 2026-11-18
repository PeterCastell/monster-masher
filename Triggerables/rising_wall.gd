@tool
extends Triggerable

@export var duration_override : int = -1
@export var does_ease : bool = true
@export var normally_open: bool = false:
	get: return normally_open
	set(v):
		normally_open = v
		(func():
			$AnimatableBody2D.position = Vector2.UP * length * 64 if !normally_open else Vector2.ZERO
		).call_deferred()

@export_range(2, 200, 1) var length: int:
	get: return length
	set(v):
		length = v
		(func():
			$AnimatableBody2D/NinePatchRect.size.y = length * 64
			($AnimatableBody2D/CollisionShape2D.shape as RectangleShape2D).size.y = v * 64
			$AnimatableBody2D/CollisionShape2D.position.y = v * 32
			if !normally_open:
				$AnimatableBody2D.position = Vector2.UP * length * 64
		).call_deferred()
@export_range(2, 5, 1) var width: int:
	get: return width
	set(v):
		width = v
		(func():
			($Base.texture as AtlasTexture).region.position.y = (5 - v)*31
			$Base.position.x = v*32
			$AnimatableBody2D/NinePatchRect.size.x = v * 64
			($AnimatableBody2D/CollisionShape2D.shape as RectangleShape2D).size.x = v * 64
			$AnimatableBody2D/CollisionShape2D.position.x = v * 32
		).call_deferred()

@export_range(0, 4, 1) var icon: int = 0:
	get: return icon
	set(v):
		icon = v
		$Icon.index = icon

@export_tool_button("Snap") var snap_btn = func(): position = round(position / 64) * 64

func _ready() -> void:
	if !normally_open:
		$AnimatableBody2D.position = Vector2.UP * length * 64

func rise(is_on: bool, duration:float):
	
	var closed = is_on if normally_open else !is_on
	
	if(duration_override != -1 and duration != 0):
		duration = duration_override
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if (closed):
	#tween.parallel(true)
		if(does_ease):
			tween.tween_property($AnimatableBody2D, "position", Vector2.UP * length * 64 ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		else:
			tween.tween_property($AnimatableBody2D, "position", Vector2.UP * length * 64 ,duration)
			
	else: 
		if(does_ease):
			tween.tween_property($AnimatableBody2D, "position", Vector2.ZERO ,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		else:
			tween.tween_property($AnimatableBody2D, "position", Vector2.ZERO ,duration)
