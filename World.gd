extends Node2D

var temp_spawn = 100

func _ready():
	if Server.is_client:
		subscribe_to_client()
	else:
		subscribe_to_server()
		
func subscribe_to_server():
	Server.connect("player_entered", self, "_on_player_entered")
	
func _on_player_entered(player_id):
	create_player(player_id)
	var newPlayer = get_node(str(player_id))
	print("created player")
	
func create_player(player_id):
	var Player = preload("res://Player/Player.tscn")
	var player = Player.instance()
	player.register(player_id)
	add_child(player)
	player.position.y = temp_spawn
	temp_spawn += 100

func subscribe_to_client():
	Server.connect("update", self, "_on_update")
	
func _on_update(world_state):
	for player_id in world_state.players:
		if get_node(str(player_id)) == null:
			create_player(player_id)
	
