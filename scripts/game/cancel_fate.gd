extends Control

@export var current_character = ""

@onready var buttons = $character_select/HBoxContainer.get_children()

var current_targets

func initialize(character, items, targets):
	if (items.has("blunderbuss")):
		$question/VBoxContainer/blunderbuss.show()
		
	if (items.has("trap")):
		$question/VBoxContainer/trap.show()
		
	current_character = character
	current_targets = targets

func _on_blunderbuss_pressed() -> void:
	init_char_select("blunderbuss")

func _on_trap_pressed() -> void:
	init_char_select("trap")

func init_char_select(item):
	var characters = get_node("/root/game/players")
	var game_node = get_node("/root/game")
	var i = 0
	
	for location in GameManager.const_locations:
		for current_char in characters.get_children():
			if (!current_char.is_dead && current_char.current_location == location && current_targets.has(current_char.name) && !game_node.fate_canceled.has(current_char.name)):
				buttons[i].text = current_char.name
				i += 1
	
	for k in range(i, buttons.size()):
		buttons[k].hide()
	
	for button in buttons:
		button.pressed.connect(use_item.bind(button.text, item))
	
	$question.hide()
	$character_select.show()
	
func use_item(character, item):
	var main_character = get_node("/root/game/players").get_node(current_character)
	var game_node = get_node("/root/game")
	
	GameManager.send_message.rpc(current_character + " cancels fate with " + item + " for " + character)
	CardManager.delete_card.rpc_id(main_character.player_id, item, character, main_character.get_path())
	
	game_node.cancel_fate_for_character.rpc(character)
	
	self.queue_free()
	
				
func _on_close_button_pressed() -> void:
	$question.show()
	$character_select.hide()
