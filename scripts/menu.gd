extends Control

@onready var name_panel = $name_background
@onready var username = $name_background/username
@onready var host_button = $Panel/host_button
@onready var join_button = $Panel/join_button
@onready var settings_button = $Panel/settings_button
@onready var exit_button = $Panel/exit_button

var current_status

func _ready() -> void:
	name_panel.hide()

func _on_host_button_pressed() -> void:
	name_panel.show()
	disable_buttons()
	current_status = "Host"

func _on_join_button_pressed() -> void:
	name_panel.show()
	disable_buttons()
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
	enable_buttons()
	
func disable_buttons() -> void:
	host_button.disabled = true
	join_button.disabled = true
	settings_button.disabled = true
	exit_button.disabled = true

func enable_buttons() -> void:
	host_button.disabled = false
	join_button.disabled = false
	settings_button.disabled = false
	exit_button.disabled = false
