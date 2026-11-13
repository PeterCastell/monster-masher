extends CanvasLayer
class_name Canvas

var can_view_operation_screen = true
var operation_toggled = false

var played = false
@onready var start_lightning: ColorRect = $MainMenu/StartLightning

func _ready():
	# pause
	get_tree().paused = true
	
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and can_view_operation_screen:
		if $AnimationPlayer.is_playing():
			return
		if !operation_toggled:
			$AnimationPlayer.play("slide_down2")
			operation_toggled = true
		else:
			$AnimationPlayer.play_backwards("slide_down2")
			operation_toggled = false

func _on_play_button_pressed() -> void:
	start_lightning.visible = true
	$Timer.start(0.25)
	


func _on_timer_timeout() -> void:
	$FadeAnimator.play("fade")

	


func _on_fade_animator_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "fade" and  not played):
		get_tree().paused = false
		$MainMenu.visible = false
		start_lightning.visible = false
		$FadeAnimator.play_backwards("fade")
		played = true
