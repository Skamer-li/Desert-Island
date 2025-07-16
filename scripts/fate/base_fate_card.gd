extends Node

@export var card_fullname = ""
@export var card_name = ""
@export var card_target = ""
@export var resource = ""
@export var number = 0
@export var current_location = ""

signal fate_played 

@onready var effect = $effect

func set_properties(card: String):
	$texture.texture=load(card)
	card_fullname = card
	card = card.get_file()
	card_name = card.get_slice("_",0)
	card_target = card.get_slice("_",1)
	number = int(card.get_slice("_",2))
	resource = card.get_slice("_",3)
	effect.set_script(load("res://scripts/fate/"+card_name+".gd"))

@rpc("any_peer","call_local")
func show_fate():
	var card_scene = preload("res://scenes/fate/base_fate_card.tscn")
	var scene = card_scene.instantiate()
	self.add_child(scene)
	get_node("BaseFateCard").scale=Vector2(2,2)
	get_node("BaseFateCard").set_properties(card_fullname)
	get_node("BaseFateCard").show()
	fate_played.emit()
