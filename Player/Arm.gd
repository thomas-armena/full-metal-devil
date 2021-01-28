extends Node2D

const BULLET_CONTROLLER = preload("res://BulletController.tscn")

enum ArmState {
	idle,
	cooldown,
}

var state = ArmState.idle

func shoot():
	if state == ArmState.cooldown: return
	var bullet_controller = BULLET_CONTROLLER.instance()
	get_node("/root/World").add_child(bullet_controller)
	var rand_rot = rand_range(-PI/10, PI/10)
	bullet_controller.spawn_bullet($BulletSpawnPoint.global_position, global_rotation + rand_rot)
	state = ArmState.cooldown
	$Cooldown.start()

	
func _on_Cooldown_timeout():
	state = ArmState.idle
