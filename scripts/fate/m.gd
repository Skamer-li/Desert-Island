extends Node

func fate_activated():
	var target = get_parent().card_target
	var players = 0
	match(target):
		"c":
			$"../../../players".get_node("Cherpack").wound_amount+=1
		"cap":
			$"../../../players".get_node("The Captain").wound_amount+=1
		"fm":
			$"../../../players".get_node("First Mate").wound_amount+=1
		"k":
			$"../../../players".get_node("The Kid").wound_amount+=1
		"m":
			$"../../../players".get_node("Milady").wound_amount+=1
		"s":
			$"../../../players".get_node("Snob").wound_amount+=1
		_:
			pass	
	
