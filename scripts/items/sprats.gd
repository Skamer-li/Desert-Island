extends Node

@rpc ("any_peer")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	player.food_amount += card.food_gain
