extends Node2D

var current_turn = 0
var current_location = "Beach"
var current_player_id = 0
var current_character_name = "Name"
var cards_dealed = false
var game_end = false

@rpc ("any_peer")
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
				cards_dealed = false
				continue
		
		current_player_id = player_id_on_location(current_location)
		current_character_name = character_name_on_location(current_location)
		
		match (current_player_id):
			0:
				continue
			1:
				if (!cards_dealed && GameManager.items.size() >= characters_alive()):
					$actions/cards_dealing.set_cards_to_deal(GameManager.items)
				else:
					show_actions()
			_:
				if (!cards_dealed && GameManager.items.size() >= characters_alive()):
					$actions/cards_dealing.set_cards_to_deal.rpc_id(current_player_id, GameManager.items)
				else:
					show_actions.rpc_id(current_player_id)
		
		return
	
func player_id_on_location(location: String) -> int:
	for player in $players.get_children():
		if (player.current_location == location && player.is_dead == false):
			return player.player_id
	return 0
	
func character_name_on_location(location: String) -> String:
	for character in $players.get_children():
		if (character.current_location == location):
			return character.character_name
	return "Name"
	
func characters_alive() -> int:
	var char_count = 0
	
	for character in $players.get_children():
		if (character.is_dead == false):
			char_count += 1
			
	return char_count

@rpc
func show_actions():
	$actions/basic_actions.show()
	
@rpc ("any_peer")
func cards_dealed_info() -> void:
	cards_dealed = true

func _on_actions_action_finished() -> void:
	game_loop()

func _on_shuffle_players_are_ready() -> void:
	game_loop()

func _on_cards_dealing_cards_dealing_finished() -> void:
	if multiplayer.is_server():
		cards_dealed_info()
		show_actions()
	else:
		cards_dealed_info.rpc_id(1)
		show_actions()
