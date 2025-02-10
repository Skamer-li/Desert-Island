extends Node2D

@export var value = 6
var scene = preload("res://scenes/items/candelabrum.tscn")

@rpc ("any_peer")
func item_use():
	pass
