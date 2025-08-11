extends Sprite2D

@onready var food_slider = $menus/food_choice/food_slider
@onready var card_list = preload("res://scenes/character_inventory.tscn")

var character
var target
var target_node

func update_values():
	food_slider.min_value = 0
	food_slider.max_value = target_node.food_amount
	food_slider.step = 1
	$menus/food_choice/food_amount.text = str(food_slider.value)

func initialize(character_name, target_name):
	character = character_name
	target = target_name
	target_node = $"../../players".get_node(target)
	update_values()
	food_slider.value = 0
	
func _on_open_card_pressed() -> void:
	if ($menus.get_node("open_cards") != null):
		for card in $menus.get_node("open_cards").get_node("card_spawn_point").get_children():
			card.card_pressed.disconnect(_on_card_selected)
		$menus.get_node("open_cards").queue_free()
	
	if ($"../../players".get_node(target).inventory_activated.size() != 0):
		var card_scene = card_list.instantiate()
		card_scene.name = "open_cards"
		$menus.add_child(card_scene)
	
		for item in target_node.inventory_activated:
			card_scene.add_card(item)
		
		for card in card_scene.get_node("card_spawn_point").get_children():
			card.card_pressed.connect(_on_card_selected.bind(card.card_name))
func _on_food_pressed() -> void:
	var food_amount = $"../../players".get_node(target).food_amount
	if (food_amount > 0):
		send_fight_request("food", food_amount)

func _on_close_button_pressed() -> void:
	$menus/food_choice.hide()
	
func _on_food_slider_value_changed(value: float) -> void:
	$menus/food_choice/food_amount.text = str(value)

func _on_fight_start_pressed() -> void:
	$menus/food_choice.hide()
	send_fight_request("food", food_slider.value)

func _on_closed_card_pressed() -> void:
	if ($"../../players".get_node(target).inventory.size() != 0):
		send_fight_request("closed_card", 0)

func _on_location_pressed() -> void:
	send_fight_request("location", 0)
	
func _on_card_selected(item):
	send_fight_request("open_card", item)
	$menus.get_node_or_null("open_cards").queue_free()
	
func send_fight_request(purpose, object):
	self.hide()
	
	GameManager.increment_fate.rpc_id(1, $"../../players".get_node(character).get_path())
	
	$"../../fight/fight_menu".trade_block.rpc(true)
		
	$"../../fight".initialize_fight.rpc_id(target_node.player_id, character, target, purpose, object)
