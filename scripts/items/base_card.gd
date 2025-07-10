extends Node2D

@export var card_name = "Name"
@export var card_owner = "Name"
@export var food_amplification = 0
@export var hunger_food_decrease = 0
@export var food_gain = 0
@export var damage = 0
@export var value = 0 
@export var heal = 0
@export var build_amplification = 0
@export var can_be_activated = false

@onready var script_node = $script_node

var ability_script = null
var ability = null

func set_properties(data: Dictionary, owner: String):
	card_name = data.get("name", "Name")
	self.name = card_name
	card_owner = owner
	food_amplification = data.get("food_amplification", 0)
	hunger_food_decrease = data.get("hunger_food_decrease", 0)
	food_gain = data.get("food_gain", 0)
	damage = data.get("damage", 0)
	value = data.get("value", 0)
	heal = data.get("heal", 0)
	build_amplification = data.get("build_amplification", 0)
	can_be_activated = data.get("can_be_activated", false)
	
	self.get_parent().get_parent().inventory.append(card_name)
	
	var card_script = load("res://scripts/items/" + card_name + ".gd")
	var card_sprite = load("res://sprites/items/" + card_name + ".png")
	
	script_node.set_script(card_script)
	$texture.texture = card_sprite
	
	var no_button_items = ["candelabrum", "cup", "doubloons", "trap", "chamber_pot"]
	
	if (no_button_items.has(card_name)):
		$button.hide()

func _on_button_pressed() -> void:
	if multiplayer.is_server():
		script_node.item_use()
		if !can_be_activated:
			delete_card()
		else:
			if(GameManager.is_fight):
				self.get_parent().get_parent().get_parent().get_parent().get_node("fight").get_node("fight_menu").refresh_data.rpc()
	else:
		script_node.item_use.rpc_id(1)
		if !can_be_activated:
			delete_card()
			delete_card.rpc_id(1)
		else:
			if(GameManager.is_fight):
				self.get_parent().get_parent().get_parent().get_parent().get_node("fight").get_node("fight_menu").refresh_data.rpc()
	
@rpc ("any_peer")
func delete_card():
	self.get_parent().get_parent().inventory.erase(card_name)
	if can_be_activated:
		var char_node = self.get_parent().get_parent()
		var max_damage = 0
		
		char_node.inventory_activated.erase(card_name)
		
		#finding next max damage card
		for item in char_node.inventory_activated:
			var properties
	
			for dict in GameManager.items_database:
				if (dict.get("name", "") == item):
					properties = dict
					break
			
			var current_damage = properties.get("damage", 0)
			if (current_damage > max_damage):
				max_damage = current_damage
		
		char_node.fight_strength = char_node.base_strength + max_damage
		char_node.food_amplification -= food_amplification
	
	self.get_parent().delete_card_from_array(card_name)
	self.get_parent().reposition_cards()
	self.queue_free()

@rpc ("any_peer")
func itemss_use():
	var player = self.get_parent().get_parent()
	
	player.food_amount += food_gain
