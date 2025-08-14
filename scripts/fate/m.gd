extends Node
var fate_cards

func fate_activated(effect_targets: Array):
	for effect_target in effect_targets:
		var player_path =$"../../../players/".get_node(effect_target).get_path()
		GameManager.deal_damage(player_path)
	for card in get_parent().get_parent().get_children():
		if card.card_name==get_parent().card_name:
			card.show_fate.rpc()
	$"../../../sounds/".mosquito_attack.rpc()
	await get_tree().create_timer(2).timeout
	resolved.rpc_id(1)
	
@rpc("any_peer","call_local")
func resolved():
	fate_cards=get_parent().get_parent()
	fate_cards.fate_card_resolve.rpc()
