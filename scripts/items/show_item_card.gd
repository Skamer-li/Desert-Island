extends Node2D

@export var card_name = "card"
@export var isSelected = false

signal card_pressed

func change_texture(card_name: String):
	if (card_name == "closed"):
		$card.texture = load("res://sprites/items/items.png")
	else:
		$card.texture = load("res://sprites/items/" + card_name + ".png")

func make_selecteble():
	$CheckBox.show()
	
func _on_button_pressed() -> void:
	card_pressed.emit()
	if ($CheckBox.button_pressed):
		$CheckBox.button_pressed = false
		isSelected = false
	else:
		$CheckBox.button_pressed = true
		isSelected = true
