extends Sprite2D

@onready var players = $"../../players"

var cards_given = 0
var player_count = 0:
	set = _set_labels
var character_names = []
var player_names = []
var characters_without_card = []
var items = []

signal cards_dealing_finished

func _ready() -> void:
	self.hide()
	
	var index = 0
	
	for card in $cards.get_children():
		card.hide()
		card.pressed.connect(_on_card_pressed.bind(index))
		index += 1

@rpc
func set_cards_to_deal(items_order) -> void:
	var count = 0
	for item in items_order:
		items.append(item)
	
	
	for location in GameManager.const_locations:
		for player in $"../../players".get_children():
			if (!player.is_dead && player.current_location == location):
				player_names.append(player.player_name)
				character_names.append(player.character_name)
				characters_without_card.append(player.character_name)
				break
				
	if (items_order.size() < player_names.size()):
		$skip_char.show()
		for card in $cards.get_children():
			if (count < items_order.size()):
				card.icon = load("res://sprites/items/"+items_order[count]+".png")	
				card.show()
				count += 1
	else:	
		for card in $cards.get_children():
			if (count < player_names.size()):
				card.icon = load("res://sprites/items/"+items_order[count]+".png")	
				card.show()
				count += 1
	
	player_count = 0
	
	self.show()

func _set_labels(value: int) -> void:
	player_count = value
	if (player_count == player_names.size() && characters_without_card.size() == 0 || cards_given == items.size()):
		player_count = 0
		cards_given = 0
		player_names.clear()
		character_names.clear()
		characters_without_card.clear()
		$skip_char.hide()
		self.hide()
		items.clear()
		cards_dealing_finished.emit()
	else:
		$character_name.text = character_names[player_count]
		$player_name.text = player_names[player_count]

func _on_card_pressed(card_index):
	MenuClick.play()
	var player_path = players.get_node(character_names[player_count]).get_path()
	
	characters_without_card.erase(character_names[player_count])
	cards_given += 1

	CardManager.send_card_to_character.rpc_id(1, items[card_index], character_names[player_count], player_path)
	
	$cards.get_node("card" + str(card_index + 1)).hide()
	
	move_to_next()


func _on_skip_char_pressed() -> void:
	move_to_next()
		
func move_to_next():
	var validator = false
	
	for i in range(player_count + 1, character_names.size()):
		if (characters_without_card.has(character_names[i])):
			player_count = i
			validator = true
			break
	
	if (!validator):
		for i in range(0, player_count - 1):
			if (characters_without_card.has(character_names[i])):
				player_count = i
				validator = true
				break
				
	if (!validator):
		player_count = player_names.size()
