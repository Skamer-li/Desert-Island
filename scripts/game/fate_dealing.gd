extends Sprite2D

signal fate_dealing_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
@rpc("any_peer")
func card_to_the_back(pos):
	GameManager.fate_deck.remove_at(pos)
	GameManager.fate_deck.append(GameManager.fate_deck.pop_at(0))
	
@rpc("any_peer")
func drawing_fate_cards(fate_deck):
	$fate/BaseFateCard.set_properties(fate_deck[0]) 
	$fate/BaseFateCard2.set_properties(fate_deck[1])
	self.show()
	
@rpc("any_peer", "call_local")
func place_fate(id, full_name):
	var card_scene = preload("res://scenes/fate/base_fate_card.tscn")
	var scene = card_scene.instantiate()
	var location = "Beach"
	for player in $"../../players".get_children():
		if player.player_id==id:location=player.current_location;
	var location_position = $"../../locations".get_node(location).position
	$"../../fate_cards".add_child(scene)
	$"../../fate_cards".get_node("BaseFateCard").set_properties(full_name)
	$"../../fate_cards".get_node("BaseFateCard").show()
	$"../../fate_cards".get_node("BaseFateCard").position.x = location_position.x
	$"../../fate_cards".get_node("BaseFateCard").position.y = location_position.y+150
	if $"../../fate_cards".get_node(location+"_fate")!=null:
		var card_on_same_loc=2
		for fate_card in $"../../fate_cards".get_children():
			if fate_card.name == (location+"_fate"+str(card_on_same_loc)):
				card_on_same_loc+=1
		$"../../fate_cards".get_node("BaseFateCard").position.y = location_position.y+150+(50*(card_on_same_loc-1))
	$"../../fate_cards".get_node("BaseFateCard").name = location+"_fate"
	

@rpc("any_peer","call_local")
func give_fate(character):
	var players = 0
	for player in $"../../players".get_children():
		players += 1
	match(character):
		"c":
			$"../../players".get_node("Cherpack").char_fate+=1
		"cap":
			$"../../players".get_node("The Captain").char_fate+=1
		"fm":
			$"../../players".get_node("First Mate").char_fate+=1
		"k":
			if (players>=6):
				$"../../players".get_node("The Kid").char_fate+=1
		"m":
			if (players>=5):
				$"../../players".get_node("Milady").char_fate+=1
		"s":
			$"../../players".get_node("Snob").char_fate+=1
		_:
			pass	
@rpc("any_peer","call_local")
func add_token_location(location):
	var players = 0
	for player in $"../../players".get_children():
		players += 1
	match(location):
		1:
			$"../../locations/Beach".fate_token_amount+= 1
		2:
			$"../../locations/Jungle".fate_token_amount+=1
		3:
			$"../../locations/Swamp".fate_token_amount+=1
		4:
			$"../../locations/Spring".fate_token_amount+=1
		5:
			if (players>=5):
				$"../../locations/Hill".fate_token_amount+=1
		6:
			if (players>=6):
				$"../../locations/Cave".fate_token_amount+=1
		_:
			pass

@rpc("any_peer")
func _on_button_pressed() -> void:
	#$"../..".fate_card_value=$fate/BaseFateCard.number
	place_fate.rpc(multiplayer.get_unique_id(), $fate/BaseFateCard.card_fullname)
	add_token_location.rpc($fate/BaseFateCard.number)
	give_fate.rpc($fate/BaseFateCard.card_target)
	if multiplayer.is_server():
		card_to_the_back(0)
		change_fate_card_value($fate/BaseFateCard.number)
	else:
		card_to_the_back.rpc_id(1, 0)
		change_fate_card_value.rpc_id(1, $fate/BaseFateCard.number)
	$"../..".fate_update.rpc()

	self.hide()
	fate_dealing_finished.emit()
	
@rpc ("any_peer")
func change_fate_card_value(number):
	$"../..".fate_card_value=number

@rpc("any_peer")
func _on_button_2_pressed() -> void:
	#$"../..".fate_card_value=$fate/BaseFateCard2.number
	place_fate.rpc(multiplayer.get_unique_id(), $fate/BaseFateCard2.card_fullname)
	add_token_location.rpc($fate/BaseFateCard2.number)
	give_fate.rpc($fate/BaseFateCard2.card_target)
	if multiplayer.is_server():
		card_to_the_back(1)
		change_fate_card_value($fate/BaseFateCard2.number)
	else:
		card_to_the_back.rpc_id(1, 1)
		change_fate_card_value.rpc_id(1, $fate/BaseFateCard2.number)
	
	$"../..".fate_update.rpc()

	self.hide()
	fate_dealing_finished.emit()
