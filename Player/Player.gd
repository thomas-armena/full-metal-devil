extends KinematicBody2D

export (int) var speed = 10
var velocity = Vector2.ZERO
var player_id
var player_data

func register(id):
	set_name(str(id))
	player_id = id

enum PLAYER_STATE {
	idle
}

#func _ready():
	#if Server.is_client:
		#Server.connect("update", self, "_on_update")

func _physics_process(delta):

	if not Server.is_client:
		player_data = Server.world_state.players[player_id]
		process_velocity(delta)
		move_and_collide(velocity)
		process_rotation()
		process_body_parts()
		Server.update_player(player_id, {
			"position": position,
			"state": "idle", # TODO
		})
	
func process_rotation():
	var mouse_position = player_data.mouse_position
	print("HJE",mouse_position)
	rotation = position.angle_to_point(mouse_position) + PI 
	
func process_velocity(delta):
	
	velocity = Vector2.ZERO
	if player_data.is_pressing_right:
		velocity.x += 1
	if player_data.is_pressing_left:
		velocity.x -= 1
	if player_data.is_pressing_down:
		velocity.y += 1
	if player_data.is_pressing_up:
		velocity.y -= 1
	velocity = velocity.normalized() * delta * speed

func process_body_parts():
	set_leg_state()
	set_arm_rotations($LeftArm)
	set_arm_rotations($RightArm)
		
func set_leg_state():
	var move_angle = angle_difference(rotation, velocity.angle())
	if velocity.x == 0 and velocity.y == 0:
		$Legs.current_state = $Legs.LEG_STATE.idle
	elif abs(move_angle) > PI - PI/4:
		$Legs.current_state = $Legs.LEG_STATE.walking_backwards
	elif move_angle > PI / 6: 
		$Legs.current_state = $Legs.LEG_STATE.walking_right
	elif move_angle < -PI / 6: 
		$Legs.current_state = $Legs.LEG_STATE.walking_left
	else:
		$Legs.current_state = $Legs.LEG_STATE.walking_forward
		
func set_arm_rotations(arm):
	var mouse_position = player_data.mouse_position
	var mouse_distance = position.distance_to(mouse_position)
	arm.rotation = -asin(arm.position.y/mouse_distance)
	if mouse_distance > 100:
		arm.rotation = -asin(arm.position.y/mouse_distance)
	else:
		arm.rotation = 0

func angle_difference(angle1, angle2):
	var diff = angle2 - angle1
	if abs(diff) > PI:
		diff = -sign(diff)*(2*PI - abs(diff))
	return diff
	
### Client
	
func _process(delta):
	if Server.is_client:
		var mouse_position = $Camera2D.get_global_mouse_position()
		Server.client_mouse_position = mouse_position

