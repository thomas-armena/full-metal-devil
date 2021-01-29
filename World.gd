extends Node2D

const PLAYER = preload("res://Player/Player.tscn")
const ENEMY = preload("res://Enemies/Enemy.tscn")

var temp_spawn = 100

func _ready():
	if Server.is_client:
		subscribe_to_client()
	else:
		subscribe_to_server()
		spawn_enemies()
	
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
	for enemy_id in world_state.enemies:
		if get_node(str(enemy_id)) == null:
			create_enemy(enemy_id)
			
func spawn_enemies():
	var enemy1 = ENEMY.instance()
	enemy1.position = Vector2(500,500)
	add_child(enemy1)
	
	var enemy2 = ENEMY.instance()
	enemy2.position = Vector2(200, 300)
	add_child(enemy2)
	
func create_enemy(enemy_id):
	var enemy1 = ENEMY.instance()
	enemy1.position = Vector2(500,500)
	enemy1.initialize_from_server(enemy_id)
	add_child(enemy1)
	
