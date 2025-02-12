extends Node2D

@export var value = 0 
var scene = preload("res://scenes/items/medicine.tscn")

@rpc ("any_peer")
func item_use():
	self.get_parent().get_parent().wound_amount -= 1
