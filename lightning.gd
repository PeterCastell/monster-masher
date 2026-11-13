extends Control

var times_map = {}


func _ready() -> void:
	for child in get_children():
		times_map[child] =  [randf_range(2.0, 10.0),  randf_range(0.5, 1.0)]


func _process(delta: float) -> void:
	for key in times_map:
		var value = times_map[key]
		value[0] -= delta
		value[1] -= delta
		if(value[1] < 0):
			key.visible = false
		if(value[0] < 0 ):
			value[0] =  randf_range(2.0, 10.0)
			value[1] =  randf_range(0.2, 0.5)
			key.visible = true
			
