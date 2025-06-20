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
	self.hide()
	for child in $menus.get_children():
		child.queue_free()


func _on_hand_pressed() -> void:
	menu_interaction("self_hand", $"../..".character_name, false)


func _on_open_pressed() -> void:
	menu_interaction("self_open", $"../..".character_name, true)

func _on_button_pressed() -> void:
	menu_interaction("player_open", player_name, true)
	
func menu_interaction(menu_name, character_name, open):
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
				inv.remove(item_name)
		else:
			inv = focus_player.inventory_activated
			
		for item_name in inv:
			card_scene.add_card(item_name)
	else:
		$menus.get_node(menu_name).show()
