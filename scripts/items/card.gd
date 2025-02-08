extends Node

@export var set_card_owner = "Name":
	set = _set_card_owner
@export var card_owner = "Name"

func _set_card_owner(value: String):
	set_card_owner = value
	give_card_to_player(set_card_owner)

func give_card_to_player(player_name: String):
	if ($"../../../players".get_node(player_name).player_id == 1):
		send_card(player_name)
	else:
		send_card.rpc_id($"../../../players".get_node(player_name).player_id, player_name)
		send_card(player_name)
	
@rpc ("any_peer")
func send_card(character: String):
	var current_card = self.get_parent().scene.instantiate()
	current_card.get_node("card").card_owner = character
	$"../../../players".get_node(character).get_node("inventory").add_child(current_card)
