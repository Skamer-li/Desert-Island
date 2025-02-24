extends Node2D

@export var value = 0 

var scene = preload("res://scenes/items/boarding_saber.tscn")
var is_used = false

func _ready() -> void:
	$card.can_be_activated = true

@rpc ("any_peer")
func item_use():
	if !is_used:
		self.get_parent().get_parent().inventory_activated.append(self.name)
		is_used = true
