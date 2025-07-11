extends Sprite2D

var player_name
var your_hand_cards = []
var your_open_cards = []
var player_open_cards = []

@onready var your_food_slider = $your_side/food/food_slider
@onready var player_food_slider = $player_side/food/food_slider
@onready var player_card_slider = $player_side/cards_in_hand/card_slider

@onready var card_list = preload("res://scenes/character_inventory.tscn")

func initialize(name: String):
	$player.text = name
	player_name = name
	
	your_food_slider.value = 0
	player_food_slider.value = 0
	player_card_slider.value = 0
	
	update_values()
	
	self.show()

func update_values():
	var your_node = self.get_parent().get_parent()
	var player_node = your_node.get_parent().get_node(player_name)
	
	your_food_slider.min_value = 0
	your_food_slider.max_value = your_node.food_amount
	your_food_slider.step = 1
	
	player_food_slider.min_value = 0
	player_food_slider.max_value = player_node.food_amount
	player_food_slider.step = 1
	
	player_card_slider.min_value = 0
	player_card_slider.max_value = player_node.inventory.size() - player_node.inventory_activated.size()
	player_card_slider.step = 1
	
func _process(delta: float) -> void:
	if (player_name != null):
		update_values()
	
	$your_side/food/food_amount.text = str(your_food_slider.value)
	$player_side/food/food_amount.text = str(player_food_slider.value)
	$player_side/cards_in_hand/card_amount.text = str(player_card_slider.value)
	
func _on_close_button_pressed() -> void:
	MenuClick.play()
	self.hide()
	for child in $menus.get_children():
		child.queue_free()


func _on_hand_pressed() -> void:
	MenuClick.play()
	menu_interaction("self_hand", $"../..".character_name, false)


func _on_open_pressed() -> void:
	MenuClick.play()
	menu_interaction("self_open", $"../..".character_name, true)

func _on_button_pressed() -> void:
	MenuClick.play()
	menu_interaction("player_open", player_name, true)
	
func menu_interaction(menu_name, character_name, open):
	MenuClick.play()
	if ($menus.get_node(menu_name) == null):
		var card_scene = card_list.instantiate()
		card_scene.name = menu_name
		card_scene.make_checkbox_visible()
		$menus.add_child(card_scene)
		
		var focus_player = $"../..".get_parent().get_node(character_name)
		var inv
		
		if (!open):
			inv = focus_player.inventory
			for item_name in focus_player.inventory_activated:
				inv.erase(item_name)
		else:
			inv = focus_player.inventory_activated
			
		for item_name in inv:
			card_scene.add_card(item_name)
	else:
		$menus.get_node(menu_name).show()


func _on_send_button_pressed() -> void:
	MenuClick.play()
	var target_id = $"../..".get_parent().get_node(player_name).player_id
	print("My target is" + player_name)
	var sender_name = $"../..".character_name
	var give_food = your_food_slider.value
	var get_food = player_food_slider.value
	var closed_cards_to_get = player_card_slider.value
	
	var closed_cards_to_give = []
	if ($menus.get_node("self_hand") != null):
		for item in $menus.get_node("self_hand").get_node("card_spawn_point").get_children():
			if (item.get_node("CheckBox").button_pressed):
				MenuClick.play()
				closed_cards_to_give.append(item.card_name)
			
	var open_cards_to_get = []
	if ($menus.get_node("player_open") != null):
		for item in $menus.get_node("player_open").get_node("card_spawn_point").get_children():
			if (item.get_node("CheckBox").button_pressed):
				MenuClick.play()
				open_cards_to_get.append(item.card_name)
			
	var open_cards_to_give = []
	if ($menus.get_node("self_open") != null):
		for item in $menus.get_node("self_open").get_node("card_spawn_point").get_children():
			if (item.get_node("CheckBox").button_pressed):
				MenuClick.play()
				open_cards_to_give.append(item.card_name)
	
	#$"../recieve_trade".initialize.rpc_id(target_id, sender_name, give_food, get_food, closed_cards_to_get, closed_cards_to_give, open_cards_to_get, open_cards_to_give)
	calling.rpc_id(target_id, player_name, sender_name, give_food, get_food, closed_cards_to_get, closed_cards_to_give, open_cards_to_get, open_cards_to_give)
	for child in $menus.get_children():
		child.queue_free()
		
	self.hide()

@rpc ("any_peer")
func calling(player_name, sender_name, give_food, get_food, closed_cards_to_get, closed_cards_to_give, open_cards_to_get, open_cards_to_give):
	$"../..".get_parent().get_node(player_name).get_node("trade").get_node("recieve_trade").initialize(sender_name, give_food, get_food, closed_cards_to_get, closed_cards_to_give, open_cards_to_get, open_cards_to_give)

func _on_trade_button_pressed() -> void:
	MenuClick.play()
	var path = $"../..".get_parent().get_parent().get_node("actions").get_node("choose_player")
	path.start(true, $"../..".character_name)
