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
@export var survival_points = 0

@export var char_fate = 0
@export var location_fate = 0
@export var ratted = false
@export var eating = false

var texture_loaded = 0

func _ready() -> void:
	if (player_id != multiplayer.get_unique_id()):
		self.hide()
		
	$SkillButton.disabled = true
		

	var chat_node=get_parent().get_parent().get_node("chat")
	chat_node.player_id=player_id

func _set_food(value: int) -> void:
	food_amount = value
	$stats/food/food/food_amount.text = str(food_amount)
	
func _set_fate(value: int) -> void:
	fate_amount = char_fate + location_fate
	$stats/fate/fate/fate_amount.text = str(fate_amount)

func _set_wound(value: int) -> void:
	if (value < 0):
		value = 0
	wound_amount = value
	$stats/wound/wound/wound_amount.text = str(wound_amount)
	
	if wound_amount > 0:
		if not multiplayer.is_server():
			death_check.rpc_id(1)
		else:
			death_check()

func _set_location(value: String) -> void:
	current_location = value

func _set_player_name(value: String) -> void:
	player_name = value

func _set_character_name(value: String) -> void:
	character_name = value
	
	match(character_name):
		"Cherpack":
			if texture_loaded != 1:
				$character.texture = load("res://sprites/characters/cherpack.png")
				texture_loaded = 1
			base_strength = 6
			fight_strength = 6
			survival_points = 6
		"First Mate":
			$SkillButton.hide()
			if texture_loaded != 1:
				$character.texture = load("res://sprites/characters/first_mate.png")
				texture_loaded = 1
			base_strength = 8
			fight_strength = 8
			survival_points = 4
		"Snob":
			if texture_loaded != 1:
				$character.texture = load("res://sprites/characters/snob.png")
				texture_loaded = 1
			base_strength = 5
			fight_strength = 5
			survival_points = 7
		"The Captain":
			if texture_loaded != 1:
				$character.texture = load("res://sprites/characters/the_captain.png")
				texture_loaded = 1
			base_strength = 7
			fight_strength = 7
			survival_points = 5
		"Milady":
			if texture_loaded != 1:
				$character.texture = load("res://sprites/characters/milady.png")
				texture_loaded = 1
			base_strength = 4
			fight_strength = 4
			survival_points = 8
		"The Kid":
			if texture_loaded != 1:
				$character.texture = load("res://sprites/characters/the_kid.png")
				texture_loaded = 1
			base_strength = 4
			fight_strength = 4
			survival_points = 8
		_:
			print("Error character name set")

@rpc ("any_peer", "call_local")			
func self_texture_load(character_name: String):
		match(character_name):
			"Cherpack":
					$character.texture = load("res://sprites/characters/cherpack_dead.png")
			"First Mate":
					$character.texture = load("res://sprites/characters/first_mate_dead.png")
			"Snob":
					$character.texture = load("res://sprites/characters/snob_dead.png")
			"The Captain":
					$character.texture = load("res://sprites/characters/the_captain_dead.png")
			"Milady":
					$character.texture = load("res://sprites/characters/milady_dead.png")
			"The Kid":
					$character.texture = load("res://sprites/characters/the_kid_dead.png")
			_:
				print("Error character name set")
			
@rpc ("any_peer")			
func death_check():
	if wound_amount == base_strength:
		is_dead = true
		return true 
	return false
		
func _set_friend_name(value: String) -> void:
	friend_name = value
	
	match(friend_name):
		"Cherpack":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/cherpack_f.png")
		"First Mate":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/first_mate_f.png")
		"Snob":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/snob_f.png")
		"The Captain":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/the_captain_f.png")
		"Milady":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/milady_f.png")
		"The Kid":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/the_kid_f.png")
		_:
			print("Error character name set")

func _set_enemy_name(value: String) -> void:
	enemy_name = value
	
	match(enemy_name):
		"Cherpack":
			$"friends&enemies/background/HBoxContainer/enemy/enemy".texture = load("res://sprites/enemies/cherpack_e.png")
		"First Mate":
			$"friends&enemies/background/HBoxContainer/enemy/enemy".texture = load("res://sprites/enemies/first_mate_e.png")
		"Snob":
			$"friends&enemies/background/HBoxContainer/enemy/enemy".texture = load("res://sprites/enemies/snob_e.png")
		"The Captain":
			$"friends&enemies/background/HBoxContainer/enemy/enemy".texture = load("res://sprites/enemies/the_captain_e.png")
		"Milady":
			$"friends&enemies/background/HBoxContainer/enemy/enemy".texture = load("res://sprites/enemies/milady_e.png")
		"The Kid":
			$"friends&enemies/background/HBoxContainer/enemy/enemy".texture = load("res://sprites/enemies/the_kid_e.png")
		_:
			print("Error character name set")

func _on_button_pressed() -> void:
	MenuClick.play()
	
	match(character_name):
		"Cherpack":
			$"friends&enemies/background/HBoxContainer/friend/friend".texture = load("res://sprites/friends/cherpack_f.png")
		"Snob":
			var choice_scene = preload("res://scenes/snob_captain_skill.tscn").instantiate()
			add_child(choice_scene)
			choice_scene.initialize(character_name)
		"The Captain":
			var choice_scene = preload("res://scenes/snob_captain_skill.tscn").instantiate()
			add_child(choice_scene)
			choice_scene.initialize(character_name)
		"Milady":
			GameManager.decrement_fate.rpc_id(1, self.get_path())
			$SkillButton.disabled = true
		"The Kid":
			the_kid_action.rpc_id(1)
			$SkillButton.disabled = true

func update_fate_tokens():
	var tokens_node=get_parent().get_parent().get_node("characters").get_node(character_name).get_node("fate_tokens")
	tokens_node.fate_token_placing.rpc(char_fate,30)

@rpc ("any_peer", "call_local")
func the_kid_action():
	var location_index = GameManager.const_locations.find(current_location, 0)
	var left_index = location_index - 1
	var right_index = location_index + 1
	
	#steal food from left character
	if (left_index >= 0):
		var target_location = GameManager.const_locations[left_index]
		
		for character in self.get_parent().get_children():
			if (character.current_location == target_location):
				if (character.food_amount > 0):
					character.food_amount -= 1
					food_amount += 1
					break
	
	#steal food from right character
	if (right_index < GameManager.const_locations.size()):
		var target_location = GameManager.const_locations[right_index]
		
		for character in self.get_parent().get_children():
			if (character.current_location == target_location):
				if (character.food_amount > 0):
					character.food_amount -= 1
					food_amount += 1
					break
