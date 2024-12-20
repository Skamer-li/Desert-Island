extends Sprite2D

@export var player_id := 1:
	set(id):
		player_id = id
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
