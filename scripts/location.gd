extends Node

@onready var inventory = preload("res://scenes/character_inventory.tscn")

@export var fate_token_amount = 0
@export var current_cards = []

const CARDS = "inventory"

func set_sprite():
	self.texture=load("res://sprites/locations/"+self.name+".png")

@rpc ("any_peer", "call_local")
func set_closed_sprite():
	self.texture=load("res://sprites/locations/"+self.name+"_closed.png")

@rpc("any_peer","call_local")
#input amount of fate tokens, and radius of a circle
func fate_token_placing(fate_token_amount, circle_radius,z_index):
	var token_scene = preload("res://scenes/fate/fate_token.tscn")
	var tokens = $tokens
	for fate_token in tokens.get_children():
		fate_token.queue_free()
	for i in range(fate_token_amount):
		var token = token_scene.instantiate()
		tokens.add_child(token)
		tokens.get_node("FateToken").scale=Vector2(0.5,0.5)
		tokens.get_node("FateToken").name="fate_token_"+str(i)
	var placment_vector=Vector2(circle_radius+10,0)
	if fate_token_amount!=1 && fate_token_amount!=0:
		var count =0
		for token in tokens.get_children():
			var base_angle=(2*PI)/fate_token_amount
			token.position=placment_vector.rotated(base_angle*count)
			token.z_index=2
			count+=1
	elif fate_token_amount==1:
		for token in tokens.get_children():
			token.position=Vector2(0,0)
			token.z_index=2

@rpc ("any_peer", "call_local")
func add_card_to_location(card):
	current_cards.append(card)

@rpc ("any_peer", "call_local")
func delete_cards_from_location():
	current_cards.clear()

func _on_inventory_button_pressed() -> void:
	if (self.get_node_or_null(CARDS) != null):
		return 
	
	var new_inventory = inventory.instantiate()
	new_inventory.name = CARDS
	
	add_child(new_inventory)
	
	new_inventory.scale = Vector2(4, 4)
	
	new_inventory.global_position = Vector2(1920/2, 1080/2)
	
	for card in current_cards:
		new_inventory.add_card(card)
	
