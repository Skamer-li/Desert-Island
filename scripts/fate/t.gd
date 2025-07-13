extends Node
var game_main
var fate_cards
func _ready() -> void:
	game_main=get_parent().get_parent().get_parent()
func fate_activated(effect_target: String):
	for card in get_parent().get_parent().get_children():
		if card.card_name==get_parent().card_name:
			card.show_fate.rpc()
	$"../../../sounds/".tsunami.rpc()
	tsunami.rpc_id(1,GameManager.const_locations,effect_target)
@rpc("any_peer","call_local")
func tsunami(locations,effect_target):
	game_main=get_parent().get_parent().get_parent()
	game_main.signal_fire=0
	game_main.fire_update()
	var location = $"../../../players/".get_node(effect_target).current_location
	var location_id = GameManager.const_locations.find(location)
	for i in location_id:
		print(i,"loc_id")
		for player in $"../../../players/".get_children():
			var player_path =$"../../../players/".get_node(player.character_name).get_path()
			if player.current_location==locations[i]:
				GameManager.deal_damage(player_path)
				for item in player.inventory_activated:
					var player_id=player.player_id
					CardManager.delete_card.rpc_id(player_id,item,player,player_path)
	await get_tree().create_timer(2).timeout
	resolved.rpc()

@rpc("any_peer","call_local")
func resolved():
	fate_cards=get_parent().get_parent()
	fate_cards.fate_card_resolve.rpc()
