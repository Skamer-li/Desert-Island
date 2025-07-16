extends Node
var players = get_parent().get_parent().get_parent().get_node("players")
var fate_cards
var target

signal monkeys_finished

var inventory=[]
var inventory_active=[]

func fate_activated(effect_targets: Array):
	for card in get_parent().get_parent().get_children():
		if card.card_name==get_parent().card_name:
			card.show_fate.rpc()
	$"../../../sounds/".monkey_attack.rpc()
	for effect_target in effect_targets:
		GameManager.remove_add_monkeys.rpc_id(1,true,players.get_node(effect_target).get_path())
		target=effect_target
		monkey_business.rpc_id(players.get_node(effect_target).player_id,effect_target,players.get_node(effect_target).inventory,players.get_node(effect_target).inventory_activated)
		await monkeys_finished
	resolved.rpc_id(1)
@rpc("any_peer","call_local")
func monkey_business(target,inv,inv_act):
	var monkey_scene = preload("res://scenes/fate/monkeys.tscn")
	var monkey = monkey_scene.instantiate()
	monkey.fate_card=str(get_parent().name)
	monkey.target=str(target)
	get_parent().get_parent().get_parent().add_child(monkey)
	var monkey_node=get_parent().get_parent().get_parent().get_node("monkeys")
	monkey_node.position=Vector2(360,260)
	monkey_node.player_select(target)
	
@rpc("any_peer","call_local")
func spawn_card_select(cards_owner) -> void:
	var monkey_node
	if get_parent().get_parent().get_parent().get_node_or_null("monkeys")==null:
		var monkey_scene = preload("res://scenes/fate/monkeys.tscn")
		var monkey = monkey_scene.instantiate()
		monkey.target=cards_owner
		monkey.position=Vector2(360,260)
		monkey.fate_card=str(get_parent().name)
		monkey.get_node("Card Choice").show()
		get_parent().get_parent().get_parent().add_child(monkey)
		monkey_node=get_parent().get_parent().get_parent().get_node("monkeys")
	else:
		monkey_node=get_parent().get_parent().get_parent().get_node("monkeys")
		monkey_node.target=cards_owner
		monkey_node.fate_card=str(get_parent().name)
		monkey_node.get_node("Card Choice").show()
	monkey_node.add_cards(str(cards_owner))

@rpc("any_peer","call_local")
func resolved():
	fate_cards=get_parent().get_parent()
	fate_cards.fate_card_resolve.rpc()
	
@rpc("any_peer","call_local")
func monkey_business_finished():
	monkeys_finished.emit()
