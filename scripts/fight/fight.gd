extends Node2D

@onready var card_list = preload("res://scenes/character_inventory.tscn")
@onready var food_division = preload("res://scenes/divide_food.tscn")
@onready var hand_choice = preload("res://scenes/hand_choice.tscn")

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
	
	var message_part 
	
	match(purpose):
		"open_card":
			send_fight_message(object.replace("_", " "), sender)
		"closed_card":
			send_fight_message("card from hand", sender)
			GameManager.send_message.rpc(sender + " wants to steal " + reciever + "'s card from hand")
		"food":
			send_fight_message(str(object) + " food", sender)
			GameManager.send_message.rpc(sender + " wants to steal " + reciever + "'s " + str(object) + " food")
		"location":
			send_fight_message("location", sender)
			GameManager.send_message.rpc(sender + " wants to steal " + reciever + "'s location")
		
	

@rpc
func send_fight_message(object, sender):
	$fight_message.show()
	$fight_message/Label.text = sender + " wants to steal your " + object

@rpc ("any_peer", "call_local")
func transfer_object(object_t, sender_t, reciever_t, purpose_t):
	var sender_node = $"../players".get_node(sender_t)
	var reciever_node = $"../players".get_node(reciever_t)
	
	match(purpose_t):
		"open_card":
			CardManager.delete_card.rpc_id(reciever_node.player_id, object_t, reciever_t, reciever_node.get_path())
			CardManager.send_card_to_character(object_t, sender_t, sender_node.get_path())
			GameManager.send_message.rpc(sender_t + " stole " + reciever_t + "'s " + object_t.replace("_", " "))
		"closed_card":
			transfer_closed_card.rpc_id(sender_node.player_id, sender_t, reciever_t)
			
		"food":
			transfer_food.rpc_id(reciever_node.player_id, sender_t, reciever_t, object_t)
			
		"location":
			$"../locations".swap_locations.rpc(sender_t, reciever_t)
			GameManager.send_message.rpc(sender_t + " stole " + reciever_t + "'s " + "location")
			if (GameManager.const_locations.find(sender_node.current_location, 0) > GameManager.const_locations.find(reciever_node.current_location, 0)):
				$"..".decrement_turn()
			
	if (purpose_t != "closed_card" && purpose_t != "food"):
		$"../actions/basic_actions".disable_buttons.rpc_id(sender_node.player_id, true)
		
func _on_accept_pressed() -> void:
	transfer_object.rpc_id(1, object, sender, reciever, purpose)
	$fight_menu.trade_block.rpc(false)
	$fight_message.hide()

@rpc ("any_peer", "call_local")
func transfer_food(sender_t, reciever_t, amount):
	var scene = food_division.instantiate()
	
	sender = sender_t
	reciever = reciever_t
	
	scene.initialize(amount, reciever_t)
	add_child(scene)
	
	scene.division_finished.connect(send_left_right_request)
	
func send_left_right_request(left, right):
	var sender_node = $"../players".get_node(sender)
	instantiate_left_right_choice.rpc_id(sender_node.player_id, left, right, sender, reciever)

@rpc ("any_peer", "call_local")
func instantiate_left_right_choice(left, right, sender, reciever):
	var scene = hand_choice.instantiate()
	var sender_node_path = $"../players".get_node(sender).get_path()
	var reciever_node_path = $"../players".get_node(reciever).get_path()
	
	scene.initialize(sender_node_path, reciever_node_path, left, right, true)
	add_child(scene)

@rpc ("any_peer", "call_local")
func transfer_closed_card(sender_t, reciever_t):
	var sender_node = $"../players".get_node(sender_t)
	var reciever_node = $"../players".get_node(reciever_t)
	
	var choice_scene = card_list.instantiate()
	choice_scene.name = "closed_cards"
	add_child(choice_scene)
	
	choice_scene.position = $fight_message.position
	choice_scene.get_node("close_button").queue_free()
	
	#adding items in list to choose
	var closed_inventory = []
	
	for item in reciever_node.inventory:
		closed_inventory.append(item)
	
	for item in reciever_node.inventory_activated:
		closed_inventory.erase(item)
	
	for item in closed_inventory:
		choice_scene.add_card(item)
		
	#hiding cards
	for card in choice_scene.get_node("card_spawn_point").get_children():
		card.get_node("card").texture = load("res://sprites/items/items.png")
	
	var count = 0
	
	#binding cards as buttons
	for card in choice_scene.get_node("card_spawn_point").get_children():
		count += 1
		card.card_pressed.connect(_on_card_selected.bind(card.card_name, sender_t, reciever_t))
		
	if (count == 0):
		choice_scene.queue_free()
		$"../actions/basic_actions".disable_buttons(true)
		GameManager.send_message.rpc(reciever_t + " hasn't card in the hand")

@rpc ("any_peer", "call_local")
func deal_damage(characters):
	for character in characters:
		$"../players".get_node(character).wound_amount += 1
		
func _on_card_selected(card_name, sender_t, reciever_t):
	transfer_object.rpc_id(1, card_name, sender_t, reciever_t, "open_card")
	GameManager.send_message.rpc(sender_t + " stole " + reciever_t + "'s " + "card from hand")
		
	for card in self.get_node("closed_cards").get_node("card_spawn_point").get_children():
		card.card_pressed.disconnect(_on_card_selected)
		
	$"../actions/basic_actions".disable_buttons(true)
	
	self.get_node("closed_cards").queue_free()

func _on_close_button_pressed() -> void:
	$fight_menu.hide()

func _on_decline_pressed() -> void:
	$fight_message.hide()
	
	GameManager.increment_fate.rpc_id(1, $"../players".get_node(reciever).get_path())
	GameManager.send_message.rpc("The fight between " + sender + " and " + reciever + " begins")
	
	for character in $"../players".get_children():
		if (character.character_name == reciever):
			$fight_menu.show_fight_table(reciever, sender, reciever, true)
		elif (character.character_name == sender):
			$fight_menu.show_fight_table.rpc_id(character.player_id, sender, sender, reciever, true)
		else:
			$fight_menu.show_fight_table.rpc_id(character.player_id, character.character_name, sender, reciever, false)
