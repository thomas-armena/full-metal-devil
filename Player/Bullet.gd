extends KinematicBody2D

const MUZZLE = preload("res://Muzzle.tscn")

export (int) var speed = 3000
var velocity = Vector2()
var controller
var damage = 10

func _ready():
	controller = get_parent()
	draw_bullet_trail()

func start(dir):
	velocity = Vector2(speed, 0).rotated(dir)
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	draw_bullet_trail()
	if collision:
		handle_collision(collision)
		
func draw_bullet_trail():
	var bullet_trail = controller.get_node("BulletTrail")
	bullet_trail.add_point(position)
	while bullet_trail.get_point_count() > 10:
		bullet_trail.remove_point(0)

		
func handle_collision(collision):
	var muzzle = MUZZLE.instance()
	get_node("/root/World").add_child(muzzle)
	muzzle.position = global_position
	muzzle.rotation = collision.normal.angle() - PI/2
	
	if collision.collider.has_method("hit"):
		collision.collider.hit(damage)
	queue_free()


func _on_DeathTimer_timeout():
	queue_free()
