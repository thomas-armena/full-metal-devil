extends Node2D


enum ArmState {
	idle,
	cooldown,
}

var state = ArmState.idle

func shoot():
	if state == ArmState.cooldown: return
	var Bullet = preload("res://Player/Bullet.tscn")
	var bullet = Bullet.instance()
	bullet.start($BulletSpawnPoint.global_position, global_rotation)

	get_node("/root/World").add_child(bullet)
	
	state = ArmState.cooldown
	$Cooldown.start()

	
func _on_Cooldown_timeout():
	state = ArmState.idle
