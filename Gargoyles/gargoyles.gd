extends CharacterBody2D
class_name Gargoyle

# WIP platofrm thats easier to play on if u have flutter
# Kinda like a donut block in mario
# need to fix it so stay_up_time refreshes where youre not on it
# that might acc make flutter OP without the need for the gargoyles head to regen which is a bit clunky...
# shouldve thought of that sooner whoops

var falling : bool = false

var resetting : bool = false

var fall_spd : float = 100
var fade_spd : float = 0.85
var reset_time : float = 1 # seconds
var stay_up_time : float = 0.5 # seconds
var refresh_stay_up_time : float = 0.5 # seconds

# bad code below bc redid collisions 10 times
func _physics_process(delta: float) -> void:
	
	for body in $Area2D.get_overlapping_bodies():
		print("hi")
		if not resetting and not falling:
			if ($StayUpTime.is_stopped()):
				$StayUpTime.start(stay_up_time)
				$Reset.start(reset_time+stay_up_time)
				falling = true
	

		
	if (falling):
		if ($StayUpTime.is_stopped()):
			velocity.y += 	fall_spd* delta
			$CollisionShape2D.disabled = true
			$Face.modulate.a -= fade_spd * delta
		
	if($Reset.is_stopped() and falling):
		falling = false
		$Face.modulate.a = 1
		position = $ResetSpot.position
		$CollisionShape2D.disabled = false	
		resetting = true
	
	if (resetting):
		velocity.y -= 	2* fall_spd* delta
		if (position.y <= 0):
			position.y = 0
			resetting = false
			velocity.y = 0
			$StayUpTime.start(refresh_stay_up_time)
			
	move_and_slide()
