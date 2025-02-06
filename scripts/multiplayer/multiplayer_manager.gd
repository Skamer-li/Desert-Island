extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var status
var user_name
var multiplayer_join_scene = preload("res://scenes/join.tscn")
var player_spawn_node
var player_spawn_spots
var peers_connected = 0
var is_in_game = 0
var failed_id = -1

func become_host() -> void:
	print("%s is the host now" % user_name)
	
	player_spawn_node = get_tree().get_current_scene().get_node("Players")
	player_spawn_spots = get_tree().get_current_scene().get_node("spawn_spots")
	
	var server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(SERVER_PORT, 6)
	if (error != OK):
		print("Failed to host: " + str(error))
		return
		
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(add_player_to_game)
	multiplayer.peer_disconnected.connect(delete_player)
	
	add_player_to_game(1)

func join() -> void:
	print("Player %s joined the game!" % user_name)
		
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	
func add_player_to_game(id: int):	
	peers_connected = multiplayer.get_peers().size()
	
	if (peers_connected >= 6):
		failed_id = id
		delete_player(id)
	else:
		var player_to_add = multiplayer_join_scene.instantiate()
		player_to_add.player_id = id
		player_to_add.name = str(id)
		
		player_spawn_node.add_child(player_to_add, true)
		
		var current_player = player_spawn_node.get_node(str(id))
		match peers_connected:
			0:
				current_player.position = player_spawn_spots.get_node("spot_1").position
			1:
				current_player.position = player_spawn_spots.get_node("spot_2").position
			2:
				current_player.position = player_spawn_spots.get_node("spot_3").position
			3:
				current_player.position = player_spawn_spots.get_node("spot_4").position
			4:
				current_player.position = player_spawn_spots.get_node("spot_5").position
			5:
				current_player.position = player_spawn_spots.get_node("spot_6").position
			_:
				current_player.position = Vector2.ZERO
			
		GameManager.players_id.append(id)
		
	
func delete_player(id: int) -> void:
	print("Player %s left the game!" % id)
	if not player_spawn_node.has_node(str(id)):
		return
	player_spawn_node.get_node(str(id)).queue_free()
	var name_to_erase = GameManager.players_name[GameManager.players_id.find(id, 0)]
	GameManager.players_id.erase(id)
	GameManager.players_name.erase(name_to_erase)
	refresh_positions()
	peers_connected = multiplayer.get_peers().size()

func refresh_positions() -> void:
	var current_player
	var pos = 0
	for i in GameManager.players_id:
		current_player = player_spawn_node.get_node(str(i))
		match pos:
			0:
				current_player.position = player_spawn_spots.get_node("spot_1").position
			1:
				current_player.position = player_spawn_spots.get_node("spot_2").position
			2:
				current_player.position = player_spawn_spots.get_node("spot_3").position
			3:
				current_player.position = player_spawn_spots.get_node("spot_4").position
			4:
				current_player.position = player_spawn_spots.get_node("spot_5").position
			5:
				current_player.position = player_spawn_spots.get_node("spot_6").position
			_:
				current_player.position = Vector2.ZERO
		pos += 1

@rpc("any_peer")
func send_name(name: String) -> void:
	GameManager.players_name.append(name)
