extends Sprite2D

var character
var character_name
var fate_card_value

signal action_finished

func _on_forage_button_pressed() -> void:
	var food = fate_card_value + character.forage_food_amplification
	
	if (character.current_location == "Spring"):
		food += 3

	give_food_to_char.rpc_id(1, character_name, food)
	
	disable_buttons(true)

func _on_sfire_button_pressed() -> void:
	var amount= character.signal_fire_build
	
	if (character.current_location == "Hill"):
		amount += 1
	
	build_signal_fire.rpc_id(1, amount)
	
	disable_buttons(true)

func _on_steal_button_pressed() -> void:
	$"../choose_player".start(false, character_name)
	disable_buttons(true)
	$end_turn_button.disabled = true

func _on_end_turn_button_pressed() -> void:
	self.hide()
	
	end_turn.rpc_id(1)

@rpc ("any_peer", "call_local")
func disable_buttons(disable: bool):
	for button in self.get_children():
		if (button != $end_turn_button):
			if disable:
				button.disabled = true
			else:
				button.disabled = false
		else:
			if disable:
				button.disabled = false
			else:
				button.disabled = true

@rpc ("any_peer", "call_local")
func end_turn():
	action_finished.emit()
	
@rpc 
func show_actions(char_name: String, card_value: int) -> void:
	self.show()
	disable_buttons(false)
	character_name = char_name
	fate_card_value = card_value
	character = $"../../players".get_node(character_name)

@rpc ("any_peer", "call_local")
func give_food_to_char(char_name: String, amount: int):
	$"../../players".get_node(char_name).food_amount += amount

@rpc ("any_peer", "call_local")
func build_signal_fire(amount: int):
	$"../..".signal_fire += amount
