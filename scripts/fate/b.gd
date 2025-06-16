extends Node

func fate_activated():
	var target = get_parent().card_target
	
	match(target):
		"c":
			$"../../../players".get_node("Cherpack").wound_amount+=2
		"cap":
			$"../../../players".get_node("The Captain").wound_amount+=2
		"fm":
			$"../../../players".get_node("First Mate").wound_amount+=2
		"k":
			$"../../../players".get_node("The Kid").wound_amount+=2
		"m":
			$"../../../players".get_node("Milady").wound_amount+=2
		"s":
			$"../../../players".get_node("Snob").wound_amount+=2
		_:
			pass	
	
