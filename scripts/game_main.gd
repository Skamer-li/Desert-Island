extends Node2D

var multiplayer_join_scene = preload("res://scenes/player_join.tscn")

var spawn = 0
var count = 0

@onready var player_spawn_node = $players_list
@onready var role_label = $Label

func _ready() -> void:
	if multiplayer.is_server():
		GameManager.players_id.shuffle()
		
		for id in GameManager.players_id:
			match_role(GameManager.roles[count], id)
			if id == 1:
				give_role(GameManager.roles[count])
				count += 1
			else:
				give_role.rpc_id(id, GameManager.roles[count])
				count += 1
		
		for id in GameManager.players_id:
			send_info.rpc_id(id, GameManager.players_id)
			
		print("Cherpack - ", GameManager.cherpack_id)
		print("First Mate - ", GameManager.first_mate_id)
		print("Snob - ", GameManager.snob_id)
		print("The Captain - ", GameManager.the_captain_id)
		

func _process(delta: float) -> void:
	if multiplayer.is_server():
		if spawn == 0:
			for id in GameManager.players_id:
				spawn_player(id)
			spawn = 1

func spawn_player(id: int):
	var player_to_add = multiplayer_join_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	player_spawn_node.add_child(player_to_add, true)

func match_role(role: String, id: int) -> void:
	match (role):
		"Cherpack":
			GameManager.cherpack_id = id
		"First Mate":
			GameManager.first_mate_id = id
		"Snob":
			GameManager.snob_id = id
		"The Captain":
			GameManager.the_captain_id = id
		"Milady":
			GameManager.milady_id = id
		"The Kid":
			GameManager.the_kid_id = id

@rpc
func give_role(role: String) -> void:
	role_label.text = role
	GameManager.current_role = role
	GameManager.current_id = multiplayer.get_unique_id()
	print(GameManager.current_role, '\n')
	print(GameManager.current_id, '\n')

@rpc
func send_info(array: Array[int]) -> void:
	GameManager.players_id = array
	var count_role = 0
	for id in GameManager.players_id:
		match_role(GameManager.roles[count_role], id)
		count_role += 1
	
