extends Node

signal mouse_entered(card)
signal mouse_exited(card)

func _on_card_mouse_entered(card):
	mouse_entered.emit(card)

func _on_card_mouse_exited(card):
	mouse_exited.emit(card)

@rpc ("any_peer")
func item_use():
	pass
