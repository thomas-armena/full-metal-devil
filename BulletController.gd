extends Node2D

const BULLET = preload("res://Player/Bullet.tscn")
var bullet

func spawn_bullet(pos, dir):
	position = pos
	rotation = dir
	
	bullet = BULLET.instance()
	bullet.start(dir)
	add_child(bullet)
	
func _physics_process(delta):
	if bullet:
		$BulletTrail.add_point(bullet.position)
		while $BulletTrail.get_point_count() > 10:
			$BulletTrail.remove_point(0)

