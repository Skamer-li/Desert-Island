extends Node

@rpc ("any_peer")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	if !player.inventory_activated.has(card.card_name):
		player.forage_food_amplification += card.food_amplification
		player.inventory_activated.append(card.card_name)
		
@rpc ("any_peer")
func undo():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	
