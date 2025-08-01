extends Node

@rpc ("any_peer", "call_local")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	if !player.inventory_activated.has(card.card_name):
		player.signal_fire_build += card.build_amplification
		player.inventory_activated.append(card.card_name)
