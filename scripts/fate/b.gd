extends Node

func fate_activated(effect_target: String):
	$"../../../players".get_node(effect_target).wound_amount+=2
	$"../../../sounds/".boar_attack.rpc()
	get_parent().show_fate.rpc()
