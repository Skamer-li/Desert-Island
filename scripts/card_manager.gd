extends Node

@rpc ("any_peer")
func delete_card(card_name, target_name, target_player_path):
	var target_player = get_node(target_player_path)
	if (multiplayer.is_server()):
		target_player.get_node("Hand").get_node(card_name).delete_card()
	else:
		target_player.get_node("Hand").get_node(card_name).delete_card()
		target_player.get_node("Hand").get_node(card_name).delete_card.rpc_id(1)

@rpc ("any_peer")
func send_card_to_character(item_name: String, character_name: String, target_player_path) -> void:
	var target_player = get_node(target_player_path)
	var target_player_id = target_player.player_id
	var properties
	
	for dict in GameManager.items_database:
		if (dict.get("name", "") == item_name):
			properties = dict
			break
	
	give_card(properties, character_name, target_player_path)
	
	if (target_player_id != 1):
		give_card.rpc_id(target_player_id, properties, character_name, target_player_path)
	
	GameManager.items.erase(item_name)

@rpc ("any_peer")
func give_card(item_props: Dictionary, char_name: String, target_player_path):
	var target_player = get_node(target_player_path)
	var card_scene = preload("res://scenes/items/base_card.tscn")
	var scene = card_scene.instantiate()
	target_player.get_node("Hand").add_card(scene)
	target_player.get_node("Hand").get_node("base_card").set_properties(item_props, char_name)

@rpc ("any_peer")
#This function needs to be called as host before calling a function which will draw fate cards from the deck
func shuffle_discarded_fate(draw_amount):
	if GameManager.fate_deck.size()<draw_amount:
		for card in GameManager.fate_deck_discard:
			GameManager.fate_deck.append(card)
			GameManager.fate_deck.shuffle()
