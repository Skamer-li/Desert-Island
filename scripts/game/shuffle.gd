extends Node2D

var multiplayer_player = preload("res://scenes/player_game.tscn")
@onready var player_spawn_node = $"../players"

var spawn = 0
var count = 0
var players_in_game = 0

signal players_are_ready

func _ready() -> void:
	if multiplayer.is_server():
		match(GameManager.players_id.size()):
			4:
				GameManager.roles.erase("The Kid")
				GameManager.roles.erase("Milady")
				GameManager.friends.erase("The Kid")
				GameManager.friends.erase("Milady")
				GameManager.enemies.erase("The Kid")
				GameManager.enemies.erase("Milady")
				GameManager.locations.erase("Cave")
				GameManager.locations.erase("Hill")
			5:
				GameManager.roles.erase("The Kid")
				GameManager.friends.erase("The Kid")
				GameManager.enemies.erase("The Kid")
				GameManager.locations.erase("Cave")
			_:
				pass
		GameManager.roles.shuffle()
		GameManager.friends.shuffle()
		GameManager.enemies.shuffle()
		GameManager.locations.shuffle()
		GameManager.items.shuffle()
	in_game.rpc()

@rpc ("any_peer", "call_local", "reliable")
func in_game():
	if multiplayer.is_server():
		players_in_game += 1
		
		if players_in_game == len(GameManager.players_id):
			for id in GameManager.players_id:
				spawn_player(id)
				count += 1
			players_are_ready.emit()
		
func spawn_player(id: int):
	var player_to_add = multiplayer_player.instantiate()
	
	player_to_add.player_id = id
	player_to_add.food_amount = 4
	player_to_add.fate_amount = 0
	player_to_add.wound_amount = 0
	player_to_add.current_location = GameManager.locations[count]
	player_to_add.player_name = GameManager.players_name[count]
	player_to_add.character_name = GameManager.roles[count]
	player_to_add.friend_name = GameManager.friends[count]
	player_to_add.enemy_name = GameManager.enemies[count]
	player_to_add.name = GameManager.roles[count]
	
	player_spawn_node.add_child(player_to_add, true)
