extends Node


signal mouse_entered(card)
signal mouse_exited(card)

func _on_card_mouse_entered(card):
	mouse_entered.emit(self)

func _on_card_mouse_exited(card):
	mouse_exited.emit(self)


@rpc ("any_peer", "call_local")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	if !player.inventory_activated.has(card.card_name):
		player.forage_food_amplification += card.food_amplification
		if (player.fight_strength < player.base_strength + card.damage):
			player.fight_strength = player.base_strength + card.damage
		player.inventory_activated.append(card.card_name)
