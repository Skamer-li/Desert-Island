extends Node2D

var scene = preload("res://scenes/items/tent.tscn")

@rpc ("any_peer")
func item_use():
	if !self.get_parent().get_parent().inventory_activated.has(self.name):
		self.get_parent().get_parent().hunger_food_amount -= $card.hunger_food_decrease
		self.get_parent().get_parent().inventory_activated.append(self.name)
