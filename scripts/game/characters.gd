extends Node2D

@onready var player_spawn_node = $"../players"
@onready var locations = $"../locations"

@onready var cherpack_player = $cherpack/cherpack_player
@onready var first_mate_player = $first_mate/first_mate_player
@onready var milady_player = $milady/milady_player
@onready var snob_player = $snob/snob_player
@onready var the_captain_player = $the_captain/the_captain_player
@onready var the_kid_player = $the_kid/the_kid_player

func _ready() -> void:
	$".".visible = false

func _on_shuffle_players_are_ready() -> void:
	if multiplayer.is_server():
		if player_spawn_node.get_node_or_null("Cherpack") != null:
			send_player_name.rpc("Cherpack", player_spawn_node.get_node("Cherpack").player_name)
			send_location_position.rpc("Cherpack", locations.get_node(player_spawn_node.get_node("Cherpack").current_location).position.x)
		if player_spawn_node.get_node_or_null("First Mate") != null:
			send_player_name.rpc("First Mate", player_spawn_node.get_node("First Mate").player_name)
			send_location_position.rpc("First Mate", locations.get_node(player_spawn_node.get_node("First Mate").current_location).position.x)
		if player_spawn_node.get_node_or_null("Milady") != null:
			send_player_name.rpc("Milady", player_spawn_node.get_node("Milady").player_name)
			send_location_position.rpc("Milady", locations.get_node(player_spawn_node.get_node("Milady").current_location).position.x)
		else:
			hide_character.rpc("Milady")
		if player_spawn_node.get_node_or_null("Snob") != null:
			send_player_name.rpc("Snob", player_spawn_node.get_node("Snob").player_name)
			send_location_position.rpc("Snob", locations.get_node(player_spawn_node.get_node("Snob").current_location).position.x)
		if player_spawn_node.get_node_or_null("The Captain") != null:
			send_player_name.rpc("The Captain", player_spawn_node.get_node("The Captain").player_name)
			send_location_position.rpc("The Captain", locations.get_node(player_spawn_node.get_node("The Captain").current_location).position.x)
		if player_spawn_node.get_node_or_null("The Kid") != null:
			send_player_name.rpc("The Kid", player_spawn_node.get_node("The Kid").player_name)
			send_location_position.rpc("The Kid", locations.get_node(player_spawn_node.get_node("The Kid").current_location).position.x)
		else:
			hide_character.rpc("The Kid")
		set_cards_visible.rpc()
		
		$"../character_interaction".player_node = $"../players".get_node("Snob")
		$"../character_interaction".set_texture("Snob")
		$"../character_interaction".set_player_name($"../character_interaction".player_node.player_name)
		
@rpc ("any_peer", "call_local")
func set_cards_visible():
	$".".visible = true
	
@rpc ("any_peer", "call_local")
func hide_character(character_name: String):
	match(character_name):
		"Milady":
			milady_player.hide()
			$milady.hide()
		"The Kid":
			the_kid_player.hide()
			$the_kid.hide()
		_:
			print("There is no such name")

@rpc ("any_peer", "call_local")
func send_player_name(character_name: String, player_name: String):
	match(character_name):
			"Cherpack":
				cherpack_player.text = player_name
			"First Mate":
				first_mate_player.text = player_name
			"Milady":
				milady_player.text = player_name
			"Snob":
				snob_player.text = player_name
			"The Captain":
				the_captain_player.text = player_name
			"The Kid":
				the_kid_player.text = player_name
			_:
				print("There is no such name")

@rpc ("any_peer", "call_local")
func send_location_position(character_name: String, location_position: int):
	match(character_name):
			"Cherpack":
				$cherpack.position.x = location_position
			"First Mate":
				$first_mate.position.x = location_position
			"Milady":
				$milady.position.x = location_position
			"Snob":
				$snob.position.x = location_position
			"The Captain":
				$the_captain.position.x = location_position
			"The Kid":
				$the_kid.position.x = location_position
			_:
				print("There is no such name")
		
