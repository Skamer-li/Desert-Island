extends Node

@export var set_card_owner = "Name":
	set = _set_card_owner
@export var card_owner = "Name"

@export var food_amplification = 0
@export var hunger_food_decrease = 0
@export var food_gain = 0
@export var damage = 0
@export var value = 0 
@export var heal = 0
@export var build_amplification = 0
@export var can_be_activated = false

func _set_card_owner(value: String):
	set_card_owner = value
	give_card_to_player(set_card_owner)

func give_card_to_player(player_name: String):
	if ($"../../../players".get_node(player_name).player_id == 1):
		send_card(player_name)
	else:
		send_card.rpc_id($"../../../players".get_node(player_name).player_id, player_name)
		send_card(player_name)

func _on_button_pressed() -> void:
	if multiplayer.is_server():
		self.get_parent().item_use()
		if !can_be_activated:
			delete_card()
	else:
		self.get_parent().item_use.rpc_id(1)
		if !can_be_activated:
			delete_card()
			delete_card.rpc_id(1)

@rpc ("any_peer")
func delete_card():
	var card_name = self.get_parent().name
	self.get_parent().get_parent().get_parent().inventory.erase(card_name)
	if can_be_activated:
		self.get_parent().get_parent().get_parent().inventory_activated.erase(card_name)
	self.get_parent().queue_free()
	
@rpc ("any_peer")
func send_card(character: String):
	var current_card = self.get_parent().scene.instantiate()
	var card_name = self.get_parent().name
	current_card.get_node("card").card_owner = character
	$"../../../players".get_node(character).get_node("inventory").add_child(current_card)
	$"../../../players".get_node(character).inventory.append(card_name)
