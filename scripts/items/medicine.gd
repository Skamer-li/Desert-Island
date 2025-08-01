extends Node

@rpc ("any_peer", "call_local")
func item_use():	
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	player.wound_amount -= card.heal
