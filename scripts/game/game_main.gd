extends Node2D

var current_turn = 0
var current_location = "Beach"
var current_player_id = 0
var game_end = false

func _ready() -> void:
	$actions.hide()

func game_loop():
	while(!game_end):
		current_turn += 1
		
		match(current_turn):
			1:
				current_location = "Beach"
			2:
				current_location = "Jungle"
			3:
				current_location = "Swamp"
			4:
				current_location = "Spring"
			5:
				current_location = "Hill"
			6:
				current_location = "Cave"
			_:
				current_turn = 0
				continue
		
		current_player_id = player_id_on_location(current_location)
		
		if (current_player_id == 0):
			continue
		elif (current_player_id == 1):
			show_actions()
		else:
			show_actions.rpc_id(current_player_id)
		
		return
	
func player_id_on_location(location: String) -> int:
	for player in $players.get_children():
		if (player.current_location == location && player.is_dead == false):
			return player.player_id
	return 0

@rpc
func show_actions():
	$actions.show()

func _on_actions_action_finished() -> void:
	game_loop()

func _on_shuffle_players_are_ready() -> void:
	if multiplayer.is_server():
		game_loop()
