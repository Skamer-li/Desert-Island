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
	
	for location in GameManager.const_locations:
		for player in $"../../players".get_children():
			if (!player.is_dead && player.current_location == location):
				player_names.append(player.player_name)
				character_names.append(player.character_name)
				break
			
	for card in $cards.get_children():
		if (count < player_names.size()):
			card.icon = load("res://sprites/items/"+items_order[count]+".png")
			#match(items_order[count]):
				#"bananas":
					#card.icon = load("res://sprites/items/bananas.png")
				#"blunderbass":
					#card.icon = load("res://sprites/items/blunderbuss.png")
				#"boarding_saber":
					#card.icon = load("res://sprites/items/boarding_saber.png")
				#"candelabrum":
					#card.icon = load("res://sprites/items/candelabrum.png")
				#"chamber_pot":
					#card.icon = load("res://sprites/items/chamber_pot.png")
				#"coconut":
					#card.icon = load("res://sprites/items/coconut.png")
				#"crabs":
					#card.icon = load("res://sprites/items/crabs.png")
				#"cup":
					#card.icon = load("res://sprites/items/cup.png")
				#"doubloons":
					#card.icon = load("res://sprites/items/doubloons.png")
				#"fishing_rod":
					#card.icon = load("res://sprites/items/fishing_rod.png")
				#"garden":
					#card.icon = load("res://sprites/items/garden.png")
				#"medicine":
					#card.icon = load("res://sprites/items/medicine.png")
				#"monocle":
					#card.icon = load("res://sprites/items/monocle.png")
				#"roasted_iguana":
					#card.icon = load("res://sprites/items/roasted_iguana.png")
				#"shovel":
					#card.icon = load("res://sprites/items/shovel.png")
				#"spear":
					#card.icon = load("res://sprites/items/spear.png")
				#"spotting_scope":
					#card.icon = load("res://sprites/items/spotting_scope.png")
				#"sprats":
					#card.icon = load("res://sprites/items/sprats.png")
				#"tent":
					#card.icon = load("res://sprites/items/tent.png")
				#"trap":
					#card.icon = load("res://sprites/items/trap.png")
				#_:
					#pass
					
			card.show()
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
	var current_player_id = $"../../players".get_node(character_name).player_id
	var properties
	
	for dict in GameManager.items_database:
		if (dict.get("name", "") == item_name):
			properties = dict
			break
	
	give_card(properties, character_name)
	
	if (current_player_id != 1):
		give_card.rpc_id(current_player_id, properties, character_name)
		
	GameManager.items.erase(item_name)

@rpc ("any_peer")
func give_card(item_props: Dictionary, char_name: String):
	var card_scene = preload("res://scenes/items/base_card.tscn")
	var scene = card_scene.instantiate()
	$"../../players".get_node(char_name).get_node("inventory").add_child(scene)
	$"../../players".get_node(char_name).get_node("inventory").get_node("base_card").set_properties(item_props, char_name)
		
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
