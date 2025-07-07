extends Node

func fate_activated(effect_target: String):
	get_parent().show_fate.rpc()
	$"../../../sounds/".rat_attack.rpc()
