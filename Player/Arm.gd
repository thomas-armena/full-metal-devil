extends Node2D

const BULLET_CONTROLLER = preload("res://BulletController.tscn")
const MUZZLE = preload("res://Muzzle.tscn")

enum ArmState {
	idle,
	cooldown,
}

var state = ArmState.idle
var accuracy_cone = PI/9

func shoot(universal_random):
	if state == ArmState.cooldown: return false
	var bullet_controller = BULLET_CONTROLLER.instance()
	get_node("/root/World").add_child(bullet_controller)
	var rand_rot = universal_random*accuracy_cone - accuracy_cone/2
	bullet_controller.spawn_bullet($BulletSpawnPoint.global_position, global_rotation + rand_rot)
	state = ArmState.cooldown
	$Cooldown.start()
	$AnimatedSprite.play("shooting")
	spawn_muzzle()
	return true

func spawn_muzzle():
	var muzzle = MUZZLE.instance()
	muzzle.position = $BulletSpawnPoint.position
	add_child(muzzle)

func _on_Cooldown_timeout():
	state = ArmState.idle

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "shooting" and state == ArmState.idle:
		$AnimatedSprite.play("idle")
