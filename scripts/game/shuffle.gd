extends Node2D

@onready var role_label = $"../Label"
@onready var location_label = $"../Label2"

var multiplayer_player = preload("res://scenes/player_game.tscn")
@onready var player_spawn_node = $"../players"

var spawn = 0
var count = 0

func _ready() -> void:
	if multiplayer.is_server():
		for id in GameManager.players_id:
			if (id != 1):
				send_from_client.rpc_id(id)
			else:
				GameManager.players_name.append(MultiplayerManager.user_name)
		match(GameManager.players_id.size()):
			4:
				GameManager.roles.erase("The Kid")
				GameManager.roles.erase("Milady")
				GameManager.locations.erase("Cave")
				GameManager.locations.erase("Hill")
			5:
				GameManager.roles.erase("The Kid")
				GameManager.locations.erase("Cave")
			_:
				pass
		GameManager.roles.shuffle()
		GameManager.locations.shuffle()
	
func _process(delta: float) -> void:
	if multiplayer.is_server():
		if spawn == 0:
			for id in GameManager.players_id:
				spawn_player(id)
				count += 1
			spawn = 1

func spawn_player(id: int):
	var player_to_add = multiplayer_player.instantiate()
	player_to_add.player_id = id
	player_to_add.food_amount = 4
	player_to_add.fate_amount = 0
	player_to_add.wound_amount = 0
	player_to_add.current_location = GameManager.locations[count]
	player_to_add.player_name = GameManager.roles[count]
	player_to_add.name = GameManager.roles[count]
	player_spawn_node.add_child(player_to_add, true)

@rpc
func send_from_client() -> void:
	send_name.rpc_id(1, MultiplayerManager.user_name)

@rpc ("any_peer")
func send_name(name: String) -> void:
	GameManager.players_name.append(name)
