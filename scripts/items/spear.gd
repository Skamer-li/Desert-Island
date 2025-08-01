extends Node

@rpc ("any_peer", "call_local")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	if !player.inventory_activated.has(card.card_name):
		if (player.fight_strength < player.base_strength + card.damage):
			player.fight_strength = player.base_strength + card.damage
		player.inventory_activated.append(card.card_name)
