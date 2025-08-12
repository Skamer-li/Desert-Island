extends Control

@export var current_character = ""

@onready var buttons = $character_select/HBoxContainer.get_children()

func initialize(character, items):
	if (items.has("blunderbuss")):
		$question/VBoxContainer/blunderbuss.show()
		
	if (items.has("trap")):
		$question/VBoxContainer/trap.show()
		
	current_character = character

func _on_blunderbuss_pressed() -> void:
	init_char_select("blunderbuss")

func _on_trap_pressed() -> void:
	init_char_select("trap")

func init_char_select(item):
	var characters = get_node("/root/game/players")
	var i = 0
	
	for location in GameManager.const_locations:
		for current_char in characters.get_children():
			if (!current_char.is_dead && current_char.current_location == location):
				buttons[i].text = current_char.name
				i += 1
	
	for k in range(i, buttons.size()):
		buttons[k].hide()
	
	for button in buttons:
		button.pressed.connect(use_item.bind(button.text, item))
	
	$question.hide()
	$character_select.show()
	
func use_item(character, item):
	print(current_character + " cancels fate with " + item + " for " + character)
				
func _on_close_button_pressed() -> void:
	$question.show()
	$character_select.hide()
