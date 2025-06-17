extends Node

func fate_activated(effect_target: String):
	print(get_parent().card_fullname)
	$"../../../players".get_node(effect_target).wound_amount+=1
