extends Node



func fate_activated(effect_target: String):
	#no idea how to do this one yet
	$"../../../sounds/".monkey_attack.rpc()
	get_parent().show_fate.rpc()
