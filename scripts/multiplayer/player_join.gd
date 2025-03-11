extends Node2D

@onready var player = $"."
@onready var label = $Label

@export var player_id := 1:
	set(id):
		player_id = id
		$input_synchronizer.set_multiplayer_authority(id)

var player_name = "Sigma"

var count = 0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if multiplayer.is_server():
		player_name = $input_synchronizer.player_name
		label.text = player_name
