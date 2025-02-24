extends Node2D

var scene = preload("res://scenes/items/fishing_rod.tscn")

@rpc ("any_peer")
func item_use():
	if !self.get_parent().get_parent().inventory_activated.has(self.name):
		self.get_parent().get_parent().forage_food_amplification += $card.food_amplification
		self.get_parent().get_parent().inventory_activated.append(self.name)
