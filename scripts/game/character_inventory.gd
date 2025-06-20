extends Node2D

const CARD_SIZE_X: float = 753 * 0.35
const MAX_RANGE: int = 400
const MAX_CARDS: int = 5

@onready var card_scene = preload("res://scenes/items/show_item_card.tscn")
@onready var spawn_point = $card_spawn_point

var gap: int = 285

var checkbox_visible = false

func update_positions() -> void:
	var cards_count = 0
	var start_pos = -MAX_RANGE - 1
	
	for card in spawn_point.get_children():
		cards_count += 1
		
	while (start_pos < -MAX_RANGE):
		start_pos = (cards_count * CARD_SIZE_X + (cards_count - 1) * (gap - CARD_SIZE_X)) / 2 * (-1) + CARD_SIZE_X / 2
		if (start_pos < -MAX_RANGE):
			gap -= 0.1
	
	print(start_pos)
	var current_gap = 0
	
	for card in spawn_point.get_children():
		card.position.x = start_pos + current_gap
		current_gap += gap

func add_card(card_name: String) -> void:
	var new_card = card_scene.instantiate()
	new_card.change_texture(card_name)
	new_card.card_name = card_name
	
	if (checkbox_visible):
		new_card.make_selecteble()
	
	spawn_point.add_child(new_card)
	update_positions()

func _on_close_button_pressed() -> void:
	if (!checkbox_visible):
		self.queue_free()
	else:
		self.hide()
	
func make_checkbox_visible() -> void:
	checkbox_visible = true
