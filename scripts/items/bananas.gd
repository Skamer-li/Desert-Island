extends Node2D

var scene = preload("res://scenes/items/bananas.tscn")

func delete_card():
	pass

func _on_button_pressed() -> void:
	if multiplayer.is_server():
		item_use()
	else:
		item_use.rpc_id(1)

@rpc ("any_peer")
func item_use():
	self.get_parent().get_parent().food_amount += 4
