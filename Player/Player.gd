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

func _ready():
	if player_id == get_tree().get_network_unique_id():
		$Camera2D.current = true
	if Server.is_client:
		Server.connect("update", self, "_on_update")

func _physics_process(delta):

	if not Server.is_client:
		player_data = Server.world_state.players[player_id]
		process_velocity(delta)
		move_and_collide(velocity)
		process_rotation(player_data.mouse_position)
		process_body_parts(velocity, player_data.mouse_position)
		Server.update_player(player_id, {
			"position": position,
			"velocity": velocity,
			"state": "idle", # TODO
		})
	
func process_rotation(mouse_position):
	rotation = position.angle_to_point(mouse_position) + PI/2
	
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

func process_body_parts(velocity, mouse_position):
	set_leg_state(velocity, mouse_position)
	set_arm_rotations($LeftArm, velocity, mouse_position)
	set_arm_rotations($RightArm, velocity, mouse_position)
		
func set_leg_state(velocity, mouse_position):
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
		
func set_arm_rotations(arm, velocity, mouse_position):
	var mouse_distance = position.distance_to(mouse_position)
	if mouse_distance > 60:
		arm.rotation = asin(arm.position.x/mouse_distance)
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
		
func _on_update(world_state):
	#if player_id == get_tree().get_network_unique_id():
	var server_player = world_state.players[player_id]
	position = server_player.position
	process_rotation(server_player.mouse_position)
	process_body_parts(server_player.velocity, server_player.mouse_position)
		
	

