extends Node2D

@onready var player = $"."
@onready var label = $Label
@onready var input_synchronizer = $input_synchronizer

@export var player_id := 1:
	set(id):
		player_id = id
		$input_synchronizer.set_multiplayer_authority(id)

@export var player_name = "Sigma"

func _ready() -> void:
	player_name = MultiplayerManager.user_name
	label.text = player_name

func _process(delta: float) -> void:
	#Gets input and changes of client 
	player_name = input_synchronizer.player_name
	#Just host can apply changes 
	if multiplayer.is_server():
		label.text = player_name
