extends RigidBody2D
class_name Part

const HELD_ITEM_GUI = preload("uid://dg485oyxsde6g")

@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable: Area2D = $Interactable

var icon : Held_Item_Gui = null

func _ready() -> void:
	interactable.interact = pick_up


func get_type() ->  Game.Parts:
	print("abstract function")
	return Game.Parts.WEREWOLF_CLAWS

func give_ability() -> void:
	print("abstract function")

func disable_ability() -> void:
	print("abstract function")

func drop_from_player(pos: Vector2):
	icon.queue_free()
	global_position = pos
	disable_ability()
	Game.instance.player.held_part = null
	
	
func pick_up():
	icon = HELD_ITEM_GUI.instantiate()
	Game.instance.canvas.icon_holder.add_child(icon)
	icon.set_icon(sprite.texture)
	give_ability()
	Game.instance.player.held_part = self
	interactable.is_interactable = false
	
	# i want to keep the reference for the graves
	global_position = Game.instance.world.offScreenParts.global_position
	#queue_free()
