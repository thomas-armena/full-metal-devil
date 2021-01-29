extends KinematicBody2D

var hp = 100

var enemy_id

func _ready():
	if Server.is_client: subscribe_to_client()
	else: register_with_server()

func _physics_process(delta):
	if not Server.is_client: update_server_state()
	
func register_with_server():
	enemy_id = get_instance_id()
	set_name(str(enemy_id))
	Server.register_enemy(enemy_id)

func update_server_state():
	Server.update_enemy(enemy_id, {
		position = position,
		hp = hp,
	})

func _process(delta):
	$HealthIndicator.text = "health: "+str(hp)
	
func hit(damage):
	if Server.is_client: return
	hp -= damage
	
### CLIENT

func initialize_from_server(id):
	enemy_id = id
	set_name(str(enemy_id))

func subscribe_to_client():
	Server.connect("update", self, "_on_update")
	
func _on_update(world_state):
	hp = world_state.enemies[enemy_id].hp
	position = world_state.enemies[enemy_id].position
	
