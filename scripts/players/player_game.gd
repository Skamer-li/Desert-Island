extends Node2D

@onready var food_label = $food/food_amount
@onready var fate_label = $fate/fate_amount
@onready var wound_label = $wound/wound_amount
@onready var character_sprite = $character

var node_ready = false

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

func _ready() -> void:
	if (player_id != multiplayer.get_unique_id()):
		self.hide()
	food_label.text = str(food_amount)
	fate_label.text = str(fate_amount)
	wound_label.text = str(wound_amount)
	
	node_ready = true

func _process(delta: float) -> void:
	pass
	
func _set_food(value: int) -> void:
	food_amount = value
	if node_ready == true:
		food_label.text = str(food_amount)
	
func _set_fate(value: int) -> void:
	fate_amount = value
	if node_ready == true:
		fate_label.text = str(fate_amount)

func _set_wound(value: int) -> void:
	wound_amount = value
	if node_ready == true:
		wound_label.text = str(wound_amount)

func _set_location(value: String) -> void:
	current_location = value

func _set_player_name(value: String) -> void:
	player_name = value

func _set_character_name(value: String) -> void:
	character_name = value
	match(character_name):
		"Cherpack":
			$character.texture = load("res://sprites/characters/cherpack.png")
		"First Mate":
			$character.texture = load("res://sprites/characters/first_mate.png")
		"Snob":
			$character.texture = load("res://sprites/characters/snob.png")
		"The Captain":
			$character.texture = load("res://sprites/characters/the_captain.png")
		"Milady":
			$character.texture = load("res://sprites/characters/milady.png")
		"The Kid":
			$character.texture = load("res://sprites/characters/the_kid.png")
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
