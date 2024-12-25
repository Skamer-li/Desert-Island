extends Control

@onready var name_panel = $name_background
@onready var username = $name_background/username

var current_status

func _ready() -> void:
	name_panel.hide()

func _on_host_button_pressed() -> void:
	name_panel.show()
	current_status = "Host"

func _on_join_button_pressed() -> void:
	name_panel.show()
	current_status = "Client"

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_ok_button_pressed() -> void:
	if (username.text != ""):
		MultiplayerManager.user_name = username.text
		if (current_status == "Host"):
			MultiplayerManager.status = "Host"
		elif (current_status == "Client"):
			MultiplayerManager.status = "Client"
		get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")

func _on_close_button_pressed() -> void:
	name_panel.hide()
