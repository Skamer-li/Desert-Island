extends Node2D

var scene = preload("res://scenes/items/roasted_iguana.tscn")

@rpc ("any_peer")
func item_use():
	self.get_parent().get_parent().food_amount += $card.food_gain
