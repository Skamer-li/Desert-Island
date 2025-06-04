extends Sprite2D

signal fate_dealing_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()

	
@rpc("any_peer")
func drawing_fate_cards():
	$fate/BaseFateCard.set_properties(GameManager.fate_deck[0])
	$fate/BaseFateCard2.set_properties(GameManager.fate_deck[1])
	self.show()
	
@rpc
func place_fate(card):
	var number = card.number
	match (number):
		1:
			$"../../fate_cards/FateCard".set_properties(card.card_fullname)
			$"../../fate_cards/FateCard".show()
		2:
			$"../../fate_cards/FateCard2".set_properties(card.card_fullname)
			$"../../fate_cards/FateCard2".show()
		3:
			$"../../fate_cards/FateCard3".set_properties(card.card_fullname)
			$"../../fate_cards/FateCard3".show()
		4:
			$"../../fate_cards/FateCard4".set_properties(card.card_fullname)
			$"../../fate_cards/FateCard4".show()
		5:
			if (GameManager.players_id.size()>=5):
				$"../../fate_cards/FateCard5".set_properties(card.card_fullname)
				$"../../fate_cards/FateCard5".show()
		6:
			if (GameManager.players_id.size()>=6):
				$"../../fate_cards/FateCard6".set_properties(card.card_fullname)
				$"../../fate_cards/FateCard6".show()
		_:
			pass


@rpc("any_peer")
func _on_button_pressed() -> void:
	if multiplayer.is_server():
		place_fate($fate/BaseFateCard)
	else:
		place_fate.rpc_id(1,$fate/BaseFateCard)
	GameManager.fate_deck.remove_at(0)
	GameManager.fate_deck.append(GameManager.fate_deck.pop_at(0))
	self.hide()
	fate_dealing_finished.emit()

@rpc("any_peer")
func _on_button_2_pressed() -> void:
	if multiplayer.is_server():
		place_fate($fate/BaseFateCard2)
	else:
		place_fate.rpc_id(1,$fate/BaseFateCard2)
	GameManager.fate_deck.remove_at(1)
	GameManager.fate_deck.append(GameManager.fate_deck.pop_at(0))
	self.hide()
	fate_dealing_finished.emit()
