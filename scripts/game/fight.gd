extends Node2D

@onready var card_list = preload("res://scenes/character_inventory.tscn")

var sender
var reciever

var purpose
var object

@rpc ("any_peer")
func initialize_fight(sender, reciever, purpose, object):
	self.sender = sender
	self.reciever = reciever
	self.purpose = purpose
	self.object = object
	
	match(purpose):
		"open_card":
			send_fight_message(object.replace("_", " "), sender)
		"closed_card":
			send_fight_message("card from hand", sender)
		"food":
			send_fight_message(str(object) + " food", sender)
		"location":
			send_fight_message("location", sender)

@rpc
func send_fight_message(object, sender):
	$fight_message.show()
	$fight_message/Label.text = sender + " wants to steal your " + object

func give_up():
	pass

func start_fight():
	pass

@rpc ("any_peer")
func transfer_object(object_t, sender_t, reciever_t, purpose_t):
	var sender_node = $"../players".get_node(sender_t)
	var reciever_node = $"../players".get_node(reciever_t)
	
	match(purpose_t):
		"open_card":
			if (reciever_node.player_id == 1):
				CardManager.delete_card(object_t, reciever_t, reciever_node.get_path())
			else:
				CardManager.delete_card.rpc_id(reciever_node.player_id, object_t, reciever_t, reciever_node.get_path())
			
			CardManager.send_card_to_character(object_t, sender_t, sender_node.get_path())
			
			if (sender_node.player_id == 1):
				$"../actions/basic_actions".disable_buttons(true)
			else:
				$"../actions/basic_actions".disable_buttons.rpc_id(sender_node.player_id, true)
		"closed_card":
			if (sender_node.player_id == 1):
				transfer_closed_card(sender_t, reciever_t)
			else:
				transfer_closed_card.rpc_id(sender_node.player_id, sender_t, reciever_t)
		"food":
			sender_node.food_amount += object_t
			reciever_node.food_amount -= object_t
			if (sender_node.player_id == 1):
				$"../actions/basic_actions".disable_buttons(true)
			else:
				$"../actions/basic_actions".disable_buttons.rpc_id(sender_node.player_id, true)
		"location":
			$"../locations".swap_locations.rpc(sender_t, reciever_t)
			if (GameManager.const_locations.find(sender_node.current_location, 0) > GameManager.const_locations.find(reciever_node.current_location, 0)):
				$"..".decrement_turn()
			if (sender_node.player_id == 1):
				$"../actions/basic_actions".disable_buttons(true)
			else:
				$"../actions/basic_actions".disable_buttons.rpc_id(sender_node.player_id, true)
			
			

func _on_accept_pressed() -> void:
	if (multiplayer.is_server()):
		transfer_object(object, sender, reciever, purpose)
	else:
		transfer_object.rpc_id(1, object, sender, reciever, purpose)
	
	$fight_message.hide()

@rpc ("any_peer")
func transfer_closed_card(sender_t, reciever_t):
	var sender_node = $"../players".get_node(sender_t)
	var reciever_node = $"../players".get_node(reciever_t)
	
	var choice_scene = card_list.instantiate()
	choice_scene.name = "closed_cards"
	add_child(choice_scene)
	
	choice_scene.position = $fight_message.position
	choice_scene.get_node("close_button").queue_free()
	
	var closed_inventory = []
	
	for item in reciever_node.inventory:
		closed_inventory.append(item)
	
	for item in reciever_node.inventory_activated:
		closed_inventory.erase(item)
	
	for item in closed_inventory:
		choice_scene.add_card(item)
	
	for card in choice_scene.get_node("card_spawn_point").get_children():
		card.card_pressed.connect(_on_card_selected.bind(card.card_name, sender_t, reciever_t))
		
func _on_card_selected(card_name, sender_t, reciever_t):
	if (multiplayer.is_server()):
		transfer_object(card_name, sender_t, reciever_t, "open_card")
	else:
		transfer_object.rpc_id(1, card_name, sender_t, reciever_t, "open_card")
	
	for card in self.get_node("closed_cards").get_node("card_spawn_point").get_children():
		card.card_pressed.disconnect(_on_card_selected)
	
	self.get_node("closed_cards").queue_free()
	
	
