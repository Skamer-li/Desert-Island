extends Sprite2D

@onready var fight_node = $"../fight_menu"

func _on_accept_pressed() -> void:
	GameManager.increment_fate.rpc_id(1, $"../../players".get_node("Cherpack").get_path())
	GameManager.send_message.rpc("Cherpack fled the fight")
	
	$"../fight_menu".delete_char_from_fight.rpc("Cherpack")
	self.hide()
	
	$"../Timer".start()
	await $"../Timer".timeout
	
	$"../fight_menu".fight_calculations.rpc_id($"../../players".get_node($"../fight_menu".side2).player_id)

func _on_decline_pressed() -> void:
	var reciever_node = $"../../players".get_node(fight_node.side2)
	fight_node.fight_calculations.rpc_id(reciever_node.player_id)
	self.hide()


	
	
		
