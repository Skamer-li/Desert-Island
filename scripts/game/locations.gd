extends Node2D

@onready var beach = $Beach
@onready var jungle = $Jungle
@onready var swamp = $Swamp
@onready var spring = $Spring
@onready var hill = $Hill
@onready var cave = $Cave

var active_players

func _ready() -> void:
	if multiplayer.is_server():
		active_players = GameManager.players_id.size()
		
		for id in GameManager.players_id:
			if id == 1:
				locations_adjustment(active_players)
			else:
				locations_adjustment.rpc_id(id, active_players)

func _process(delta: float) -> void:
	pass

@rpc 
func locations_adjustment(players_amount: int):
	match(players_amount):
			4:
				hill.hide()
				cave.hide()
			5:
				cave.hide()
			_:
				pass
