extends Node2D

var scene = preload("res://scenes/items/spear.tscn")

@rpc ("any_peer")
func item_use():
	if !self.get_parent().get_parent().inventory_activated.has(self.name):
		if (self.get_parent().get_parent().fight_strength < self.get_parent().get_parent().base_strength + $card.damage):
			self.get_parent().get_parent().fight_strength = self.get_parent().get_parent().base_strength + $card.damage
		self.get_parent().get_parent().inventory_activated.append(self.name)
