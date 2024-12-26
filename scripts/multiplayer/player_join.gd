extends Sprite2D

@export var SPEED = 25

@onready var player = $"."
@onready var label = $Label
@onready var input_synchronizer = $input_synchronizer
@onready var axis_current = Vector2.ZERO

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
	axis_current = input_synchronizer.axis
	player_name = input_synchronizer.player_name
	
	#Just host can apply changes 
	if multiplayer.is_server():
		apply_movement()
		label.text = player_name
	
func apply_movement() -> void:
	if (axis_current.x > 0):
		player.position.x += SPEED
	elif (axis_current.x < 0):
		player.position.x -= SPEED
	
	if (axis_current.y > 0):
		player.position.y -= SPEED
	elif (axis_current.y < 0):
		player.position.y += SPEED
