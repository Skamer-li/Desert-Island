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
	
	match(card_name):
		"bananas":
			script_node.set_script(preload("res://scripts/items/bansnas.gd"))
			$texture.texture = load("res://sprites/items/bananas.png")
		"blunderbass":
			script_node.set_script(preload("res://scripts/items/blunderbass.gd"))
			$texture.texture = load("res://sprites/items/blunderbuss.png")
		"boarding_saber":
			script_node.set_script(preload("res://scripts/items/boarding_saber.gd"))
			$texture.texture = load("res://sprites/items/boarding_saber.png")
		"candelabrum":
			script_node.set_script(preload("res://scripts/items/candelabrum.gd"))
			$texture.texture = load("res://sprites/items/candelabrum.png")
			$button.hide()
		"chamber_pot":
			script_node.set_script(preload("res://scripts/items/chamber_pot.gd"))
			$texture.texture = load("res://sprites/items/chamber_pot.png")
			$button.hide()
		"coconut":
			script_node.set_script(preload("res://scripts/items/coconut.gd"))
			$texture.texture = load("res://sprites/items/coconut.png")
		"crabs":
			script_node.set_script(preload("res://scripts/items/crabs.gd"))
			$texture.texture = load("res://sprites/items/crabs.png")
		"cup":
			script_node.set_script(preload("res://scripts/items/cup.gd"))
			$texture.texture = load("res://sprites/items/cup.png")
			$button.hide()
		"doubloons":
			script_node.set_script(preload("res://scripts/items/doubloons.gd"))
			$texture.texture = load("res://sprites/items/doubloons.png")
			$button.hide()
		"fishing_rod":
			script_node.set_script(preload("res://scripts/items/fishing_rod.gd"))
			$texture.texture = load("res://sprites/items/fishing_rod.png")
		"garden":
			script_node.set_script(preload("res://scripts/items/garden.gd"))
			$texture.texture = load("res://sprites/items/garden.png")
		"medicine":
			script_node.set_script(preload("res://scripts/items/medicine.gd"))
			$texture.texture = load("res://sprites/items/medicine.png")
		"monocle":
			script_node.set_script(preload("res://scripts/items/monocle.gd"))
			$texture.texture = load("res://sprites/items/monocle.png")
		"roasted_iguana":
			script_node.set_script(preload("res://scripts/items/roasted_iguana.gd"))
			$texture.texture = load("res://sprites/items/roasted_iguana.png")
		"shovel":
			script_node.set_script(preload("res://scripts/items/shovel.gd"))
			$texture.texture = load("res://sprites/items/shovel.png")
		"spear":
			script_node.set_script(preload("res://scripts/items/spear.gd"))
			$texture.texture = load("res://sprites/items/spear.png")
		"spotting_scope":
			script_node.set_script(preload("res://scripts/items/spotting_scope.gd"))
			$texture.texture = load("res://sprites/items/spotting_scope.png")
		"sprats":
			script_node.set_script(preload("res://scripts/items/sprats.gd"))
			$texture.texture = load("res://sprites/items/sprats.png")
		"tent":
			script_node.set_script(preload("res://scripts/items/tent.gd"))
			$texture.texture = load("res://sprites/items/tent.png")
		"trap":
			script_node.set_script(preload("res://scripts/items/trap.gd"))
			$texture.texture = load("res://sprites/items/trap.png")
			$button.hide()
		_:
			pass

func _on_button_pressed() -> void:
	if multiplayer.is_server():
		script_node.item_use()
		if !can_be_activated:
			delete_card()
	else:
		script_node.item_use.rpc_id(1)
		if !can_be_activated:
			delete_card()
			delete_card.rpc_id(1)

@rpc ("any_peer")
func delete_card():
	self.get_parent().get_parent().inventory.erase(card_name)
	if can_be_activated:
		self.get_parent().get_parent().inventory_activated.erase(card_name)
	self.queue_free()

@rpc ("any_peer")
func itemss_use():
	var player = self.get_parent().get_parent()
	
	player.food_amount += food_gain
