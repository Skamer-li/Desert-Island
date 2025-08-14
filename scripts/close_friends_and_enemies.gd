extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(close)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func close():
	MenuClick.play()
	$"../..".hide()
