extends Node2D

var scene = preload("res://scenes/items/spotting_scope.tscn")

@rpc ("any_peer")
func item_use():
	if !self.get_parent().get_parent().inventory_activated.has(self.name):
		self.get_parent().get_parent().signal_fire_build += $card.build_amplification
		self.get_parent().get_parent().inventory_activated.append(self.name)
