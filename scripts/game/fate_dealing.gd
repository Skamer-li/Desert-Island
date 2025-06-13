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
func place_fate(number, full_name):
	var players = 0
	for player in $"../../players".get_children():
		players += 1
		
	match (number):
		1:
			$"../../fate_cards/FateCard".set_properties(full_name)
			$"../../fate_cards/FateCard".show()
		2:
			$"../../fate_cards/FateCard2".set_properties(full_name)
			$"../../fate_cards/FateCard2".show()
		3:
			$"../../fate_cards/FateCard3".set_properties(full_name)
			$"../../fate_cards/FateCard3".show()
		4:
			$"../../fate_cards/FateCard4".set_properties(full_name)
			$"../../fate_cards/FateCard4".show()
		5:
			if (players>=5):
				$"../../fate_cards/FateCard5".set_properties(full_name)
				$"../../fate_cards/FateCard5".show()
		6:
			if (players>=6):
				$"../../fate_cards/FateCard6".set_properties(full_name)
				$"../../fate_cards/FateCard6".show()
		_:
			pass
			
@rpc("any_peer","call_local")
func give_fate(character):
	match(character):
		"c":
			$"../../players".get_node("Cherpack").char_fate+=1
		"cap":
			$"../../players".get_node("The Captain").char_fate+=1
		"fm":
			$"../../players".get_node("First Mate").char_fate+=1
		"k":
			$"../../players".get_node("The Kid").char_fate+=1
		"m":
			$"../../players".get_node("Milady").char_fate+=1
		"s":
			$"../../players".get_node("Snob").char_fate+=1
		_:
			pass	
@rpc("any_peer","call_local")
func add_token_location(location):
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
			$"../../locations/Hill".fate_token_amount+=1
		6:
			$"../../locations/Cave".fate_token_amount+=1
		_:
			pass
@rpc("any_peer")
func _on_button_pressed() -> void:
	$"../..".fate_card_value=$fate/BaseFateCard.number
	place_fate.rpc($fate/BaseFateCard.number, $fate/BaseFateCard.card_fullname)
	add_token_location.rpc($fate/BaseFateCard.number)
	give_fate.rpc($fate/BaseFateCard.card_target)
	if multiplayer.is_server():
		card_to_the_back(0)
	else:
		card_to_the_back.rpc_id(1, 0)
	$"../..".fate_update.rpc()
	self.hide()
	fate_dealing_finished.emit()

@rpc("any_peer")
func _on_button_2_pressed() -> void:
	$"../..".fate_card_value=$fate/BaseFateCard2.number
	place_fate.rpc($fate/BaseFateCard2.number, $fate/BaseFateCard2.card_fullname)
	add_token_location.rpc($fate/BaseFateCard2.number)
	give_fate.rpc($fate/BaseFateCard2.card_target)
	if multiplayer.is_server():
		card_to_the_back(1)
	else:
		card_to_the_back.rpc_id(1, 1)
	
	$"../..".fate_update.rpc()
	self.hide()
	fate_dealing_finished.emit()
