extends CharacterBody2D
class_name Part

const HELD_ITEM_GUI = preload("uid://dg485oyxsde6g")

@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable: Area2D = $Interactable

var icon : Held_Item_Gui = null

var used : bool = false
var grv : float = 1000


func _ready() -> void:
	interactable.interact = pick_up
	interactable.interact_group = "PART"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector2.DOWN * grv * delta
	else:
		velocity.y = 0.0   

	move_and_slide()

func get_type() ->  Game.Parts:
	print("abstract function")
	return Game.Parts.WEREWOLF_CLAWS

func give_ability() -> void:
	print("abstract function")

func disable_ability() -> void:
	print("abstract function")

func drop_from_player(pos: Vector2):
	Game.instance.player.held_part = null
	global_position = pos
	used = false
	disable_ability()
	interactable.is_interactable = true
	icon.queue_free()
	
func pick_up():
	# i want to keep the reference for the graves resetting
	global_position = Game.instance.world.offScreenParts.global_position
	used = true
	if (Game.instance.player.held_part != null):
		Game.instance.player.drop_item()
		
	icon = HELD_ITEM_GUI.instantiate()
	Game.instance.canvas.icon_holder.add_child(icon)
	icon.set_icon(sprite.texture)
	give_ability()
	Game.instance.player.held_part = self
	interactable.is_interactable = false
	

	#queue_free()
