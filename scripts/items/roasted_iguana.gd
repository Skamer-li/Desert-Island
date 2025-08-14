extends Node

signal mouse_entered(card)
signal mouse_exited(card)

func _on_card_mouse_entered(card):
	mouse_entered.emit(self)

func _on_card_mouse_exited(card):
	mouse_exited.emit(self)

@rpc ("any_peer")
func item_use():
	var card = self.get_parent()
	var player = self.get_parent().get_parent().get_parent()
	
	player.food_amount += card.food_gain
