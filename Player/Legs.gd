extends Node2D

enum LEG_STATE {
	walking_left, 
	walking_right,
	walking_forward,
	walking_backwards,
	idle
}

export (LEG_STATE) var current_state = LEG_STATE.idle

func _ready():
	pass # Replace with function body.

func _process(delta):
	if current_state == LEG_STATE.idle:
		rotation = 0
		hide()
		$AnimatedSprite.play("idle")
	elif current_state == LEG_STATE.walking_forward:
		rotation = 0
		show()
		$AnimatedSprite.play("walking")
	elif current_state == LEG_STATE.walking_left:
		rotation = - PI/7
		show()
		$AnimatedSprite.play("walking")
	elif current_state == LEG_STATE.walking_right:
		rotation = PI/7
		show()
		$AnimatedSprite.play("walking")
	elif current_state == LEG_STATE.walking_backwards:
		rotation = 0
		show()
		$AnimatedSprite.play("walking", true)
