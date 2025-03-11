extends Node

@rpc ("any_peer")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	if !player.inventory_activated.has(card.card_name):
		player.hunger_food_amount -= card.hunger_food_decrease
		player.inventory_activated.append(card.card_name)
