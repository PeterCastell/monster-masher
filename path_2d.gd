extends Path2D

# https://www.youtube.com/watch?v=iwNQ2sqH2cw
@export var speed = 2.0
@export var speed_scale = 1.0
@export var animName = "move"

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer



func _ready() -> void:
	print("Playing animation: ", animName)
	animation.play(animName)
	animation.get_animation(animName).loop_mode = Animation.LOOP_LINEAR
	
#func _process(delta: float) -> void:
	#path.progress += speed
