extends Node
var fate_cards
var game_node= get_parent().get_parent().get_parent()
var players = get_parent().get_parent().get_parent().get_node("players")
var rat_node 
var target
var targets=[]

func fate_activated(effect_targets: Array):
	var player_amount = 0
	rat_node=$"../../../actions/rats"
	for effect_target in effect_targets:
		targets.append(players.get_node(effect_target))
	for card in get_parent().get_parent().get_children():
		if card.card_name==get_parent().card_name:
			card.show_fate.rpc()
	$"../../../sounds/".rat_attack.rpc()
	for target in targets:
		GameManager.decrease_food_amount.rpc_id(1,target.get_path(),target.food_amount)
		player_amount += 1
	var rat_targets=[]
	for player in players.get_children():
		if targets.has(player):
			GameManager.remove_add_rats.rpc_id(1,false,player.get_path())
			continue
		else:
			rat_targets.append(player)
		GameManager.remove_add_rats.rpc_id(1,true,player.get_path())
	for player in rat_targets:
		if !player.is_dead:
			rat_attack.rpc_id(player.player_id,str(player.name))
		
	if (player_amount == players.get_children().size()):
		resolved.rpc()
	
@rpc("any_peer","call_local")
func rat_attack(player: String) -> void:
	rat_node=$"../../../actions/rats"
	target=players.get_node(player)
	var food_divide_scene=preload("res://scenes/divide_food.tscn")
	var food_divide_node=food_divide_scene.instantiate()
	food_divide_node.initialize(target.food_amount, target.name)
	rat_node.add_child(food_divide_node)
	food_divide_node=rat_node.get_node("divide_food")
	rat_node.connect_food_division()
	
@rpc("any_peer","call_local")
func resolved():
	fate_cards=get_parent().get_parent()
	fate_cards.fate_card_resolve.rpc()
