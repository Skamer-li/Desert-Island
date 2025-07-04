extends Sprite2D

@onready var players = $"../../players"

var player_count = 0:
	set = _set_labels
var character_names = []
var player_names = []
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
				break
			
	for card in $cards.get_children():
		if (count < player_names.size()):
			card.icon = load("res://sprites/items/"+items_order[count]+".png")	
			card.show()
			count += 1
	
	player_count = 0
	
	self.show()

func _set_labels(value: int) -> void:
	player_count = value
	if (player_count == player_names.size()):
		player_count = 0
		player_names.clear()
		character_names.clear()
		self.hide()
		items.clear()
		cards_dealing_finished.emit()
	else:
		$character_name.text = character_names[player_count]
		$player_name.text = player_names[player_count]

func _on_card_pressed(card_index):
	MenuClick.play()
	var player_path = players.get_node(character_names[player_count]).get_path()
	if multiplayer.is_server():
		CardManager.send_card_to_character(items[card_index], character_names[player_count], player_path)
	else:
		CardManager.send_card_to_character.rpc_id(1, items[card_index], character_names[player_count], player_path)
	
	$cards.get_node("card" + str(card_index + 1)).hide()
	
	player_count += 1
