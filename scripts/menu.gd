extends Control

var status = "Host"

func _on_host_button_pressed() -> void:
	MultiplayerManager.status = "Host"
	#MultiplayerManager.become_host()
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")

func _on_join_button_pressed() -> void:
	MultiplayerManager.status = "Client"
	#MultiplayerManager.join()
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
