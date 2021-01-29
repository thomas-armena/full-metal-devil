extends Node2D

const BULLET = preload("res://Player/Bullet.tscn")
var bullet

func spawn_bullet(pos, dir):
	position = pos
	rotation = dir
	
	bullet = BULLET.instance()
	bullet.start(dir)
	add_child(bullet)
	
func _process(delta):
	if not bullet:
		handle_bullet_death()
			
func handle_bullet_death():
	if $BulletTrail.get_point_count() > 0:
		$BulletTrail.remove_point(0)
