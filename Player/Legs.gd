extends Node2D

enum LEG_STATE {
	walking_left, 
	walking_right,
	walking_forward,
	walking_backwards,
	idle
}

export (LEG_STATE) var current_state = LEG_STATE.idle

func _process(delta):
	if current_state == LEG_STATE.idle:
		hide()
	elif current_state == LEG_STATE.walking_forward:
		show()
		$AnimatedSprite.play("walking")
	elif current_state == LEG_STATE.walking_left:
		show()
		$AnimatedSprite.play("walking")
	elif current_state == LEG_STATE.walking_right:
		show()
		$AnimatedSprite.play("walking")
	elif current_state == LEG_STATE.walking_backwards:
		show()
		$AnimatedSprite.play("walking", true)
