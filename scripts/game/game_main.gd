extends Node2D

@onready var basic_actions = $actions/basic_actions

@export var fate_card_value = 0
@export var signal_fire = 0

var current_turn = 0
var current_location = "Beach"
var current_player_id = 0
var current_character_name = "Name"
var cards_dealed = false
var fate_dealed = 0
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
				fate_dealed = 0
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
					if(fate_dealed < characters_alive()):
						$actions/fate_dealing.drawing_fate_cards(GameManager.fate_deck)
					basic_actions.show_actions(current_character_name, fate_card_value)
			_:
				if (!cards_dealed && GameManager.items.size() >= characters_alive()):
					$actions/cards_dealing.set_cards_to_deal.rpc_id(current_player_id, GameManager.items)
				else:
					if(fate_dealed < characters_alive()):
						$actions/fate_dealing.drawing_fate_cards.rpc_id(current_player_id, GameManager.fate_deck)
					basic_actions.show_actions.rpc_id(current_player_id, current_character_name, fate_card_value)
		
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

func swamp_food_lose():
	if (current_location == "Swamp"):
		var current_character = $players.get_node(current_character_name)
		if (current_character.food_amount != 0):
			current_character.food_amount -= 1
@rpc("any_peer","call_local")
func fate_update():
	for character in $players.get_children():
		character.location_fate=$locations.get_node(character.current_location).fate_token_amount

@rpc ("any_peer")
func show_actions_as_host():
	basic_actions.show_actions.rpc_id(current_player_id, current_character_name, fate_card_value)

@rpc ("any_peer")
func draw_fate_as_host():
	$actions/fate_dealing.drawing_fate_cards.rpc_id(current_player_id, GameManager.fate_deck)
	
@rpc ("any_peer")
func cards_dealed_info() -> void:
	cards_dealed = true

@rpc ("any_peer")
func fate_dealed_info() -> void:
	fate_dealed +=1 
	
func _on_shuffle_players_are_ready() -> void:
	game_loop()

func _on_cards_dealing_cards_dealing_finished() -> void:
	if multiplayer.is_server():
		cards_dealed_info()
		$actions/fate_dealing.drawing_fate_cards(GameManager.fate_deck)
	else:
		cards_dealed_info.rpc_id(1)
		draw_fate_as_host.rpc_id(1)

func _on_basic_actions_action_finished() -> void:
	swamp_food_lose()
	print(signal_fire)
	game_loop()


func _on_fate_dealing_fate_dealing_finished() -> void:
	if multiplayer.is_server():
		fate_dealed_info()
		basic_actions.show_actions(current_character_name, fate_card_value)
	else:
		fate_dealed_info.rpc_id(1)
		show_actions_as_host.rpc_id(1)
