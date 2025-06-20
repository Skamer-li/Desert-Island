extends Control

var master_bus =AudioServer.get_bus_index("Master")
var menus_bus =AudioServer.get_bus_index("Menu")
var music_bus =AudioServer.get_bus_index("Music")
var effects_bus =AudioServer.get_bus_index("Effects")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_back_button_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")



func _on_master_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.




func _on_master_mute_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(master_bus, toggled_on)
