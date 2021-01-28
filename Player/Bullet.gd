extends KinematicBody2D

var speed = 3000
var velocity = Vector2()
var controller

func start(dir):
	velocity = Vector2(speed, 0).rotated(dir)
	controller = get_parent()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
			
		
