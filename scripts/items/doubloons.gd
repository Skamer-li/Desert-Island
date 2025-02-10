extends Node2D

@export var value = 3
var scene = preload("res://scenes/items/doubloons.tscn")

@rpc ("any_peer")
func item_use():
	pass
