extends Node2D

var multiplayer_join_scene = preload("res://scenes/player_join.tscn")
var spawn = 0
@onready var player_spawn_node = $players_list

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if spawn == 0:
		for i in GameManager.players_id:
			spawn_player(i)
			spawn = 1
	

func spawn_player(id: int):
	var player_to_add = multiplayer_join_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	player_spawn_node.add_child(player_to_add, true)
	
