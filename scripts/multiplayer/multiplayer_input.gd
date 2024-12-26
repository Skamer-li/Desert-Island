extends MultiplayerSynchronizer

#This script detects input and changes of client and synchronizes it with host
@onready var axis = Vector2.ZERO

var player_name

func _ready() -> void:
	player_name = MultiplayerManager.user_name
	get_input_axis()
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

func _process(delta: float) -> void:
	get_input_axis()

func get_input_axis() -> void:
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_up")) - int(Input.is_action_pressed("move_down"))
