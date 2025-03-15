extends Node2D

@onready var character_card_node = preload("res://scenes/character_interaction.tscn")
@onready var player_spawn_node = $"../players"
@onready var locations = $"../locations"

func _ready() -> void:
	$".".visible = false

func _on_shuffle_players_are_ready() -> void:
	if multiplayer.is_server():
		if player_spawn_node.get_node_or_null("Cherpack") != null:
			instantiate_character_card_node.rpc("Cherpack")
		if player_spawn_node.get_node_or_null("First Mate") != null:
			instantiate_character_card_node.rpc("First Mate")
		if player_spawn_node.get_node_or_null("Milady") != null:
			instantiate_character_card_node.rpc("Milady")
		if player_spawn_node.get_node_or_null("Snob") != null:
			instantiate_character_card_node.rpc("Snob")
		if player_spawn_node.get_node_or_null("The Captain") != null:
			instantiate_character_card_node.rpc("The Captain")
		if player_spawn_node.get_node_or_null("The Kid") != null:
			instantiate_character_card_node.rpc("The Kid")
		
		refresh_positions.rpc()
		set_cards_visible.rpc()

@rpc ("call_local")
func instantiate_character_card_node(character_name: String):
	var character = character_card_node.instantiate()
	character.name = character_name
	
	add_child(character)
	
	character.player_node = player_spawn_node.get_node(character_name)
	character.set_texture(character_name)
	character.set_player_name(player_spawn_node.get_node(character_name).player_name)

@rpc ("any_peer", "call_local")
func set_cards_visible():
	$".".visible = true
	
@rpc ("call_local")
func hide_character(character_name: String):
	self.get_node(character_name).hide()

@rpc ("call_local")
func refresh_positions():
	var y_scale = 300
	for character in self.get_children():
		var char_name = str(character.name)
		var location_position = $"../locations".get_node(player_spawn_node.get_node(char_name).current_location).position
		character.position.x = location_position.x
		character.position.y = location_position.y - y_scale
