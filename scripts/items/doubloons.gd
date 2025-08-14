extends Node


signal mouse_entered(card)
signal mouse_exited(card)

func _on_card_mouse_entered(card):
	mouse_entered.emit(self)

func _on_card_mouse_exited(card):
	mouse_exited.emit(self)


@rpc ("any_peer", "call_local")
func item_use():
	pass
