extends Node2D

@export var value = 7
var scene = preload("res://scenes/items/cup.tscn")

@rpc ("any_peer")
func item_use():
	pass
