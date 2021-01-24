extends KinematicBody2D

var speed = 10
var velocity = Vector2.ZERO

func _physics_process(delta):
	process_rotation()
	process_velocity(delta)
	
func process_rotation():
	rotation = position.angle_to_point(get_viewport().get_mouse_position()) + PI 
	
func process_velocity(delta):
	var is_pressing_right = Input.is_key_pressed(KEY_D)
	var is_pressing_left = Input.is_key_pressed(KEY_A)
	var is_pressing_up = Input.is_key_pressed(KEY_W)
	var is_pressing_down = Input.is_key_pressed(KEY_S)
	
	velocity.x = 0
	velocity.y = 0
	if is_pressing_right:
		velocity.x += 1
	if is_pressing_left:
		velocity.x -= 1
	if is_pressing_down:
		velocity.y -= 1
	if is_pressing_up:
		velocity.y += 1
	velocity = velocity.normalized() * delta * speed
	print(velocity)
