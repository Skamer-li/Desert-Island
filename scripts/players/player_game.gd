extends Node2D

@export var food_amount = 4:
	set = _set_food
	
@export var fate_amount = 0:
	set = _set_fate
	
@export var wound_amount = 0:
	set = _set_wound
	
@export var current_location = "Beach":
	set = _set_location
	
@export var player_name = "Name":
	set = _set_player_name
	
@export var character_name = "Name":
	set = _set_character_name
	
@export var player_id := 1:
	set(id):
		player_id = id
		
@export var friend_name = "Name":
	set = _set_friend_name
	
@export var enemy_name = "Name":
	set = _set_enemy_name
	
@export var base_strength = 0
@export var fight_strength = 0

@export var forage_food_amplification = 0
@export var hunger_food_amount = 0

@export var signal_fire_build = 1

@export var inventory: Array[String] = []
@export var inventory_activated: Array[String] = []

@export var is_dead = false

func _ready() -> void:
	if (player_id != multiplayer.get_unique_id()):
		self.hide()
		
func _set_food(value: int) -> void:
	food_amount = value
	$food/food_amount.text = str(food_amount)
	
func _set_fate(value: int) -> void:
	fate_amount = value
	$fate/fate_amount.text = str(fate_amount)

func _set_wound(value: int) -> void:
	if (value < 0):
		value = 0
	wound_amount = value
	$wound/wound_amount.text = str(wound_amount)

func _set_location(value: String) -> void:
	current_location = value

func _set_player_name(value: String) -> void:
	player_name = value

func _set_character_name(value: String) -> void:
	character_name = value
	
	match(character_name):
		"Cherpack":
			$character.texture = load("res://sprites/characters/cherpack.png")
			base_strength = 6
		"First Mate":
			$character.texture = load("res://sprites/characters/first_mate.png")
			base_strength = 8
		"Snob":
			$character.texture = load("res://sprites/characters/snob.png")
			base_strength = 5
		"The Captain":
			$character.texture = load("res://sprites/characters/the_captain.png")
			base_strength = 7
		"Milady":
			$character.texture = load("res://sprites/characters/milady.png")
			base_strength = 4
		"The Kid":
			$character.texture = load("res://sprites/characters/the_kid.png")
			base_strength = 4
		_:
			print("Error character name set")
			
func death():
	pass

func _set_friend_name(value: String) -> void:
	friend_name = value
	
	match(friend_name):
		"Cherpack":
			$friend.texture = load("res://sprites/friends/cherpack_f.png")
		"First Mate":
			$friend.texture = load("res://sprites/friends/first_mate_f.png")
		"Snob":
			$friend.texture = load("res://sprites/friends/snob_f.png")
		"The Captain":
			$friend.texture = load("res://sprites/friends/the_captain_f.png")
		"Milady":
			$friend.texture = load("res://sprites/friends/milady_f.png")
		"The Kid":
			$friend.texture = load("res://sprites/friends/the_kid_f.png")
		_:
			print("Error character name set")

func _set_enemy_name(value: String) -> void:
	enemy_name = value
	
	match(enemy_name):
		"Cherpack":
			$enemy.texture = load("res://sprites/enemies/cherpack_e.png")
		"First Mate":
			$enemy.texture = load("res://sprites/enemies/first_mate_e.png")
		"Snob":
			$enemy.texture = load("res://sprites/enemies/snob_e.png")
		"The Captain":
			$enemy.texture = load("res://sprites/enemies/the_captain_e.png")
		"Milady":
			$enemy.texture = load("res://sprites/enemies/milady_e.png")
		"The Kid":
			$enemy.texture = load("res://sprites/enemies/the_kid_e.png")
		_:
			print("Error character name set")

func _on_button_pressed() -> void:
	if not multiplayer.is_server():
		deal_damage.rpc_id(1)
	else:
		deal_damage()

@rpc ("any_peer")
func deal_damage():
	var characters = self.get_parent()
	characters.get_node("Snob").wound_amount += 1
