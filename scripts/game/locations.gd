extends Node2D

#@onready var beach = $Beach
#@onready var jungle = $Jungle
#@onready var swamp = $Swamp
#@onready var spring = $Spring
#@onready var hill = $Hill
#@onready var cave = $Cave

var active_players

func _ready() -> void:
	if multiplayer.is_server():
		location_spawn.rpc(GameManager.players_id.size())

@rpc("call_local","any_peer") 
func location_spawn(players_amount: int):
	var location_scene=preload("res://scenes/location.tscn")
	var card_width=188.25
	var card_y=510.25
	var x_from_border=360
	for player in players_amount:
		var location=location_scene.instantiate()
		self.add_child(location)
	var i=0
	var space_between_cards=(1920-(card_width*get_child_count())-x_from_border*2)/(get_child_count())
	for place in get_children():
		place.name = GameManager.const_locations[i]
		place.set_sprite()
		place.position.y += card_y
		place.position.x = x_from_border+card_width/2+card_width*(i)+space_between_cards*i
		i+=1

@rpc ("call_local")
func swap_locations(first_char, second_char):
	var first_node = $"../players".get_node(first_char)
	var second_node = $"../players".get_node(second_char)
	
	var temp_loc_name = first_node.current_location
	var temp_loc_pos = $"../locations".get_node(temp_loc_name).position
	
	first_node.current_location = second_node.current_location
	$"../characters".get_node(first_char).position.x = $"../locations".get_node(second_node.current_location).position.x
	
	second_node.current_location = temp_loc_name
	$"../characters".get_node(second_char).position.x = temp_loc_pos.x
