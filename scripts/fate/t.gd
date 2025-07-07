extends Node

func fate_activated(effect_target: String):
	get_parent().show_fate.rpc()	
	$"../../../sounds/".tsunami.rpc()
	if multiplayer.is_server():
		tsunami(GameManager.const_locations,effect_target)
	else:
		tsunami.rpc_id(1,GameManager.const_locations,effect_target)
@rpc("any_peer")
func tsunami(locations,effect_target):
	var location = $"../../../players/".get_node(effect_target).current_location
	var location_id = GameManager.const_locations.find(location)
	for i in location_id:
		for player in $"../../../players/".get_children():
			if player.current_location==locations[i]:
				for item in player.inventory_activated:
					var player_path =$"../../../players/".get_node(player.character_name).get_path()
					var player_id=player.player_id
					CardManager.delete_card.rpc_id(player_id,item,player,player_path)
