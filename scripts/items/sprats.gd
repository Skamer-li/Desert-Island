extends Node2D

@export var value = 0 
var scene = preload("res://scenes/items/sprats.tscn")

@rpc ("any_peer")
func item_use():
	self.get_parent().get_parent().food_amount += 5
