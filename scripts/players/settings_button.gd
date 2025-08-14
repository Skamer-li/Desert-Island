extends Button
func _ready() -> void:
	pressed.connect(open_settings)

func open_settings():
	MenuClick.play()
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
