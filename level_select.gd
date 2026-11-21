extends GridContainer
@onready var grid_container: GridContainer = $GridContainer


const LEVEL_BUTTON = preload("uid://1o1cb8d2yvka")
@onready var music: Node = $"../../../../../Music"



func _ready() -> void:
	
	for lvl in Game.instance.levels:
		var b = LEVEL_BUTTON.instantiate()
		self.add_child(b)
		
	SetUpButtons.call_deferred()
	
func SetUpButtons():
	var i = 0
	
	for child in self.get_children():
		child.label.text = str(i+1)
		child.dest = i
		i += 1
		child.played.connect(music.level_pressed)
