extends Node

@rpc ("any_peer", "call_local")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	var locations = get_node("/root/game/locations")
	
	locations.get_node(player.current_location).add_card_to_location.rpc(card.card_name)
