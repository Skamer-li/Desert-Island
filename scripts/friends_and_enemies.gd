extends Button

func _ready() -> void:
	pressed.connect(open_friends_and_enemies)

func open_friends_and_enemies():
	MenuClick.play()
	$"../../CanvasLayer/friends&enemies".show()
