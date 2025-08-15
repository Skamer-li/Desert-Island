extends Control

var inventory_node_name = "inventory"

@onready var inventory = preload("res://scenes/character_inventory.tscn")

@export var player_node = null


func set_texture(character_name: String):
	match(character_name):
		"Cherpack":
			$char_sprite.texture = load("res://sprites/characters/cherpack.png")
		"First Mate":
			$char_sprite.texture = load("res://sprites/characters/first_mate.png")
		"Snob":
			$char_sprite.texture = load("res://sprites/characters/snob.png")
		"The Captain":
			$char_sprite.texture = load("res://sprites/characters/the_captain.png")
		"Milady":
			$char_sprite.texture = load("res://sprites/characters/milady.png")
		"The Kid":
			$char_sprite.texture = load("res://sprites/characters/the_kid.png")
		_:
			print("Error character name set")
			
@rpc ("any_peer", "call_local")
func texture_load(character_name: String):

	match(character_name):
		"Cherpack":
			$char_sprite.texture = load("res://sprites/characters/cherpack_dead.png")
		"First Mate":
			$char_sprite.texture = load("res://sprites/characters/first_mate_dead.png")
		"Snob":
			$char_sprite.texture = load("res://sprites/characters/snob_dead.png")
		"The Captain":
			$char_sprite.texture = load("res://sprites/characters/the_captain_dead.png")
		"Milady":
			$char_sprite.texture = load("res://sprites/characters/milady_dead.png")
		"The Kid":
			$char_sprite.texture = load("res://sprites/characters/the_kid_dead.png")
		_:
				print("Error character name set")
		 

func set_player_name(player_name: String):
	$player_name.text = player_name

func _on_inventory_button_pressed() -> void:
	if (self.get_node_or_null(inventory_node_name) != null):
		return 
	
	var new_inventory = inventory.instantiate()
	
	new_inventory.name = inventory_node_name
	
	add_child(new_inventory)
	
	new_inventory.show_parameters(player_node.character_name)
	
	new_inventory.global_position = Vector2(1920/2, 1080/2)
	
	for card in player_node.inventory_activated:
		new_inventory.add_card(card)
	
	var closed_cards_size = player_node.inventory.size() - player_node.inventory_activated.size()
	
	for i in closed_cards_size:
		new_inventory.add_card("closed")
	
