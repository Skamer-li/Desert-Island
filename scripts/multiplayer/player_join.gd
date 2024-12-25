extends Sprite2D

@export var SPEED = 25

@onready var player = $"."
@onready var axis = Vector2.ZERO

@export var player_id := 1:
	set(id):
		player_id = id
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_input_axis()
	var amount_of_players = MultiplayerManager.count_players()
	if amount_of_players >= 3 and MultiplayerManager.status == "Host":
		WaitingRoom.start_button.show()
	if (axis.x > 0):
		player.position.x += SPEED
	elif (axis.x < 0):
		player.position.x -= SPEED
	
	if (axis.y > 0):
		player.position.y -= SPEED
	elif (axis.y < 0):
		player.position.y += SPEED

func get_input_axis() -> void:
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_up")) - int(Input.is_action_pressed("move_down"))
