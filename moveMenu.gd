extends TextureRect



var spd = 0.45
var dir = 1
var time = 0.0
var frequency = 3
var amplitude = 5
var start_y: float

var left_limit: float
var right_limit: float

@onready var text_object = $TitleLabel

func _ready():
	start_y = global_position.y
	left_limit = 150
	right_limit = 200

func _physics_process(delta: float) -> void:
	if text_object.position.x < left_limit:
		dir = 1
	if text_object.position.x > right_limit:
		dir = -1
	
	time += delta

	text_object.position.x += spd * dir

	var target_y = start_y + sin(time * frequency) * amplitude

	text_object.position.y = target_y
	
