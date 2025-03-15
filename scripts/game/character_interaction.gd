extends Control

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

func set_player_name(player_name: String):
	$player_name.text = player_name

func _on_inventory_button_pressed() -> void:
	var new_inventory = inventory.instantiate()
	add_child(new_inventory)
	
	new_inventory.global_position = Vector2(1920/2, 1080/2)
	
	for card in player_node.inventory_activated:
		new_inventory.add_card(card)
	
	var closed_cards_size = player_node.inventory.size() - player_node.inventory_activated.size()
	
	for i in closed_cards_size:
		new_inventory.add_card("closed")
	
	
