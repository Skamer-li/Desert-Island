extends Node

func fate_activated(effect_target: String):
	$"../../../players".get_node(effect_target).wound_amount+=1
	get_parent().show_fate.rpc()
	$"../../../sounds/".mosquito_attack.rpc()
