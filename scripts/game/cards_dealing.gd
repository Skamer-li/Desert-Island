extends Sprite2D

var player_count = 0:
	set = _set_labels

var character_names = []
var player_names = []
var items

signal cards_dealing_finished

func _ready() -> void:
	self.hide()
	
	for card in $cards.get_children():
		card.hide()

@rpc
func set_cards_to_deal(items_order) -> void:
	var count = 0
	items = items_order
	
	for location in GameManager.locations:
		for player in $"../../players".get_children():
			if (!player.is_dead && player.current_location == location):
				player_names.append(player.player_name)
				character_names.append(player.character_name)
			
	for card in $cards.get_children():
		if (count < player_names.size()):
			card.show()
			card.icon = $"../../items".get_node(items_order[count]).get_node("Sprite2D").texture
			count += 1
	
	player_count = 0
	
	self.show()

func _set_labels(value: int) -> void:
	player_count = value
	if (player_count == player_names.size()):
		player_count = 0
		player_names.clear()
		character_names.clear()
		self.hide()
		cards_dealing_finished.emit()
	else:
		$character_name.text = character_names[player_count]
		$player_name.text = player_names[player_count]

@rpc ("any_peer")
func send_card_to_character(item_name: String, character_name: String) -> void:
	$"../../items".get_node(item_name).get_node("card").set_card_owner = character_name
	GameManager.items.erase(item_name)
	
func _on_card_1_pressed() -> void:
	if multiplayer.is_server():
		send_card_to_character(items[0], character_names[player_count])
	else:
		send_card_to_character.rpc_id(1, items[0], character_names[player_count])
	$cards/card1.hide()
	player_count += 1

func _on_card_2_pressed() -> void:
	if multiplayer.is_server():
		send_card_to_character(items[1], character_names[player_count])
	else:
		send_card_to_character.rpc_id(1, items[1], character_names[player_count])
	$cards/card2.hide()
	player_count += 1

func _on_card_3_pressed() -> void:
	if multiplayer.is_server():
		send_card_to_character(items[2], character_names[player_count])
	else:
		send_card_to_character.rpc_id(1, items[2], character_names[player_count])
	$cards/card3.hide()
	player_count += 1

func _on_card_4_pressed() -> void:
	if multiplayer.is_server():
		send_card_to_character(items[3], character_names[player_count])
	else:
		send_card_to_character.rpc_id(1, items[3], character_names[player_count])
	$cards/card4.hide()
	player_count += 1

func _on_card_5_pressed() -> void:
	if multiplayer.is_server():
		send_card_to_character(items[4], character_names[player_count])
	else:
		send_card_to_character.rpc_id(1, items[4], character_names[player_count])
	$cards/card5.hide()
	player_count += 1

func _on_card_6_pressed() -> void:
	if multiplayer.is_server():
		send_card_to_character(items[5], character_names[player_count])
	else:
		send_card_to_character.rpc_id(1, items[5], character_names[player_count])
	$cards/card6.hide()
	player_count += 1
