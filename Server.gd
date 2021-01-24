extends Node2D

var is_client = false

var network = NetworkedMultiplayerENet.new()
var ip = "localhost"
var port = 4000
var max_players = 4

var world_state = {
	players = {}
}

### SERVER 

signal player_entered(player_id)

func init_server():
	is_client = false
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	
func _peer_connected(player_id):
	print(str(player_id) + " connected.")
	var newPlayer = {
		player_id = player_id,
		position = Vector2.ZERO,
		velocity = Vector2.ZERO,
		mouse_position = Vector2.ZERO,
		state = "idle", # TODO: Make this an enum
		is_pressing_right = false,
		is_pressing_left = false,
		is_pressing_up = false,
		is_pressing_down = false,
		is_pressing_leftshoot = false,
		is_pressing_rightshoot = false,
	}
	world_state.players[player_id] = newPlayer
	emit_signal("player_entered", player_id)
	update_clients()
	
func _peer_disconnected(player_id):
	print(str(player_id) + " disconnected.")
	
remote func update_player(player_id, change):
	for key in change:
		world_state.players[player_id][key] = change[key]
	update_clients()
	
func update_clients():
	rpc_unreliable("world_updated", world_state)
	
### CLIENT

signal update(world_state)

var client_mouse_position = Vector2(0,0) # Must be set externally
var client_left_shoot_pressed = false
var client_right_shoot_pressed = false
	
func init_client():
	print("connecting to server...")
	is_client = true
	network.create_client(ip, port)
	get_tree().network_peer = network
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("failed to connect")
	
func _on_connection_succeeded():
	print("successfully connected")
	
remote func world_updated(new_world_state):
	if is_client:
		emit_signal("update", new_world_state)
	
func _process(delta):
	if is_client:
		send_inputs()
		
func send_inputs():
	var player_id = get_tree().get_network_unique_id()
	
	# Unimportant inputs
	rpc_unreliable_id(1, "update_player", player_id, {
		is_pressing_up = Input.is_key_pressed(KEY_W),
		is_pressing_down = Input.is_key_pressed(KEY_S),
		is_pressing_left = Input.is_key_pressed(KEY_A),
		is_pressing_right = Input.is_key_pressed(KEY_D),
		mouse_position = Vector2(client_mouse_position.x, client_mouse_position.y)
	})
	
	# Important inputs
	if Input.is_action_pressed("ui_select"):
		if not client_left_shoot_pressed:
			rpc_id(1, "update_player", player_id, {
				is_pressing_leftshoot = true,
				mouse_position = client_mouse_position
			})
		client_left_shoot_pressed = true
	else:
		if client_left_shoot_pressed:
			rpc_id(1, "update_player", player_id, {
				is_pressing_leftshoot = false,
				mouse_position = client_mouse_position,
			})
		client_left_shoot_pressed = false
		
	if Input.is_action_pressed("ui_accept"):
		if not client_right_shoot_pressed:
			rpc_id(1, "update_player", player_id, {
				is_pressing_rightshoot = true,
				mouse_position = client_mouse_position
			})
		client_right_shoot_pressed = true
	else:
		if client_right_shoot_pressed:
			rpc_id(1, "update_player", player_id, {
				is_pressing_rightshoot = false,
				mouse_position = client_mouse_position,
			})
		client_right_shoot_pressed = false
	

