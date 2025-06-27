extends Sprite2D

@onready var card_list = preload("res://scenes/character_inventory.tscn")

var has_offer = false

var offerrer_name
var get_food
var give_food
var closed_cards_to_give
var closed_cards_to_get
var open_cards_to_give
var open_cards_to_get

@rpc ("any_peer")
func initialize(offerrer_name, get_food, give_food, closed_cards_to_give, closed_cards_to_get, open_cards_to_give, open_cards_to_get):
	self.offerrer_name = offerrer_name
	self.get_food = get_food
	self.give_food = give_food
	self.closed_cards_to_give = closed_cards_to_give
	self.closed_cards_to_get = closed_cards_to_get
	self.open_cards_to_give = open_cards_to_give
	self.open_cards_to_get = open_cards_to_get
	
	print("My name is" + $"../..".character_name)
	
	$offer.text = "Trade offer from " + offerrer_name
	$you_get/food/food_amount.text = str(get_food)
	$you_give/food/food_amount.text = str(give_food)
	
	has_offer = true
	
	$".".show()

func _process(delta: float) -> void:
	if (has_offer):
		var selected_cards = []
		if ($menus.get_node_or_null("item_choice") != null):
			for item in $menus.get_node("item_choice").get_node("card_spawn_point").get_children():
				if (item.get_node("CheckBox").button_pressed):
					selected_cards.append(item.card_name)
		
		$you_give/choose_cards_you_give/Label.text = str(selected_cards.size()) + "/" + str(closed_cards_to_give)
	
func basic_card_menu(items):
	var card_scene = card_list.instantiate()
	add_child(card_scene)
	
	for item in items:
		card_scene.add_card(item)

func checkbox_card_menu(menu_name):
	if ($menus.get_node(menu_name) == null):
		var card_scene = card_list.instantiate()
		card_scene.name = menu_name
		card_scene.make_checkbox_visible()
		$menus.add_child(card_scene)
		
		var focus_player = $"../.."
		var inv = focus_player.inventory
		
		for item_name in focus_player.inventory_activated:
			inv.erase(item_name)
			
		for item_name in inv:
			card_scene.add_card(item_name)
	else:
		$menus.get_node(menu_name).show()

func _on_show_cards_you_get_pressed() -> void:
	var items = []
	
	for item in open_cards_to_get:
		items.append(item)
	
	for item in closed_cards_to_get:
		items.append("closed")
		
	basic_card_menu(items)


func _on_show_cards_you_give_pressed() -> void:
	var items = []
	
	for item in open_cards_to_give:
		items.append(item)
	
	basic_card_menu(items)

func _on_choose_cards_you_give_pressed() -> void:
	checkbox_card_menu("item_choice")

func _on_decline_pressed() -> void:
	erase_data()

func erase_data():
	for child in $menus.get_children():
		child.queue_free()
	
	has_offer = false
	
	self.hide()

func _on_accept_pressed() -> void:
	var self_node = $"../.."
	var target_node = self_node.get_parent().get_node(offerrer_name)
	
	var self_food_check = true
	var target_food_check = true
	var closed_cards_to_give_check = true
	var closed_cards_to_get_check = true
	var open_cards_to_give_check = true
	var open_cards_to_get_check = true
	
	#checking if current player has food to trade
	if (self_node.food_amount < give_food):
		self_food_check = false
		print("Self no food")
	
	#checking if sender has food to trade
	if (target_node.food_amount < get_food):
		target_food_check = false
		print("Target no food")
	
	#checking if the amount of given cards is correct
	var selected_cards = []
	if ($menus.get_node("item_choice") != null):
		for item in $menus.get_node("item_choice").get_node("card_spawn_point").get_children():
			if (item.get_node("CheckBox").button_pressed):
				selected_cards.append(item.card_name)
	
	if (selected_cards.size() != closed_cards_to_give):
		closed_cards_to_give_check = false
		print("Bad amount of cards selected")
	
	#checking if sender has the closed cards he want to trade
	for item in closed_cards_to_get:
		if (!target_node.inventory.has(item)):
			closed_cards_to_get_check = false
			print("Sender don't have cards")
			break
	
	#checking if current player has the open cards he want to trade
	for item in open_cards_to_give:
		if (!self_node.inventory_activated.has(item)):
			open_cards_to_give_check = false
			print("Reciever don't have open cards")
			break
	
	#checking if sender has the open cards he want to trade
	for item in open_cards_to_get:
		if (!target_node.inventory_activated.has(item)):
			open_cards_to_get_check = false
			print("Sender don't have open cards")
			break
	
	if (self_food_check && target_food_check && closed_cards_to_give_check && closed_cards_to_get_check &&
		open_cards_to_give_check && open_cards_to_get_check):
			if (!multiplayer.is_server()):
				make_a_deal.rpc_id(1, offerrer_name, get_food, give_food, selected_cards, closed_cards_to_get, open_cards_to_give, open_cards_to_get)
			else:
				make_a_deal(offerrer_name, get_food, give_food, selected_cards, closed_cards_to_get, open_cards_to_give, open_cards_to_get)
			
			erase_data()
			
@rpc ("any_peer")
func make_a_deal(offerrer_name_make, get_food_make, give_food_make, closed_cards_to_give_make, closed_cards_to_get_make, open_cards_to_give_make, open_cards_to_get_make):
	var self_node = $"../.."
	var target_node = self_node.get_parent().get_node(offerrer_name_make)
	
	var self_node_path = self_node.get_path()
	var target_node_path = target_node.get_path()
	
	var self_items = []
	var target_items = []
	
	self_node.food_amount -= give_food_make
	self_node.food_amount += get_food_make
	
	target_node.food_amount -= get_food_make
	target_node.food_amount += give_food_make
	
	for item in closed_cards_to_give_make:
		if (self_node.player_id != 1):
			CardManager.delete_card.rpc_id(self_node.player_id, item, self_node.character_name, self_node_path)
		else:
			CardManager.delete_card(item, self_node.character_name, self_node_path)
			
		target_items.append(item)
	
	for item in closed_cards_to_get_make:
		if (target_node.player_id != 1):
			CardManager.delete_card.rpc_id(target_node.player_id, item, target_node.character_name, target_node_path)
		else:
			CardManager.delete_card(item, target_node.character_name, target_node_path)
		
		self_items.append(item)
	
	for item in open_cards_to_give_make:
		if (self_node.player_id != 1):
			CardManager.delete_card.rpc_id(self_node.player_id, item, self_node.character_name, self_node_path)
		else:
			CardManager.delete_card(item, self_node.character_name, self_node_path)
			
		target_items.append(item)
	
	for item in open_cards_to_get_make:
		if (target_node.player_id != 1):
			CardManager.delete_card.rpc_id(target_node.player_id, item, target_node.character_name, target_node_path)
		else:
			CardManager.delete_card(item, target_node.character_name, target_node_path)
			
		self_items.append(item)
	
	for item in self_items:
		CardManager.send_card_to_character(item, self_node.character_name, self_node_path)
	
	for item in target_items:
		CardManager.send_card_to_character(item, target_node.character_name, target_node_path)
