extends Node2D

@export var value = 5
var scene = preload("res://scenes/items/chamber_pot.tscn")

@rpc ("any_peer")
func item_use():
	pass
