extends Control

var master_bus =AudioServer.get_bus_index("Master")
var menus_bus =AudioServer.get_bus_index("Menu")
var music_bus =AudioServer.get_bus_index("Music")
var effects_bus =AudioServer.get_bus_index("Effects")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#master
	$Panel/master_volume/volume_slider/mute_button.button_pressed=AudioServer.is_bus_mute(master_bus)
	$Panel/master_volume/volume_slider.value=db_to_linear(AudioServer.get_bus_volume_db(master_bus))*100
	#menus
	$Panel/menus_volume/volume_slider/mute_button.button_pressed=AudioServer.is_bus_mute(menus_bus)
	$Panel/menus_volume/volume_slider.value=db_to_linear(AudioServer.get_bus_volume_db(menus_bus))*100
	#music
	$Panel/music_volume/volume_slider/mute_button.button_pressed=AudioServer.is_bus_mute(music_bus)
	$Panel/music_volume/volume_slider.value=db_to_linear(AudioServer.get_bus_volume_db(music_bus))*100
	#effects
	$Panel/effects_volume/volume_slider/mute_button.button_pressed=AudioServer.is_bus_mute(effects_bus)
	$Panel/effects_volume/volume_slider.value=db_to_linear(AudioServer.get_bus_volume_db(effects_bus))*100

func _on_back_button_pressed() -> void:
	MenuClick.play()
	await MenuClick.finished
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus,linear_to_db((value/100)))
	print(linear_to_db((value/100)))
	print(db_to_linear(AudioServer.get_bus_volume_db(master_bus))*100)


func _on_menus_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(menus_bus,linear_to_db((value/100)))


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus,linear_to_db((value/100)))


func _on_effects_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(effects_bus,linear_to_db((value/100)))


func _on_master_button_toggled(toggled_on: bool) -> void:
	MenuClick.play()
	AudioServer.set_bus_mute(master_bus,toggled_on)

func _on_menus_button_toggled(toggled_on: bool) -> void:
	MenuClick.play()
	AudioServer.set_bus_mute(menus_bus,toggled_on)
	
func _on_mute_button_button_down() -> void:
	MenuClick.play()

func _on_music_button_toggled(toggled_on: bool) -> void:
	MenuClick.play()
	AudioServer.set_bus_mute(music_bus,toggled_on)

func _on_effects_button_toggled(toggled_on: bool) -> void:
	MenuClick.play()
	AudioServer.set_bus_mute(effects_bus,toggled_on)
