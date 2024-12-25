extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var status
var multiplayer_join_scene = preload("res://scenes/player_join.tscn")
var player_spawn_node
func become_host() -> void:
	print("You're the host now")

	player_spawn_node = get_tree().get_current_scene().get_node("Players")
	var server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(SERVER_PORT, 6)
	if (error != OK):
		print("Failed to host: " + error)
		return
		
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(add_player_to_game)
	multiplayer.peer_disconnected.connect(delete_player)
	
	add_player_to_game(1)
	
func join() -> void:
	print("Joining")
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer


func add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	var player_to_add = multiplayer_join_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	player_spawn_node.add_child(player_to_add, true)

func delete_player(id: int) -> void:
	print("Player %s left the game!" % id)
	if not player_spawn_node.has_node(str(id)):
		return
	player_spawn_node.get_node(str(id)).queue_free()
func count_players():
	return int(multiplayer.get_peers().size())
