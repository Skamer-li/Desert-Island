extends Control

@onready var resolutions_option_button = $Panel/resolutions_option_button
@onready var window_mode_option_button = $Panel/window_mode_option_button

var resolutions = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}

const window_modes : Array[String] = [
	"Full-Screen", 
	"Windowed"
]

func _ready():
	add_resolutions()
	add_window_modes()
	update_button_values()

func add_resolutions() -> void:
	# Add items inside resolutions option button
	for i in resolutions:
		resolutions_option_button.add_item(i)

func update_button_values() -> void:
	# Update string inside resolutions option button box
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolutions_index = resolutions.keys().find(window_size_string)
	resolutions_option_button.selected = resolutions_index
	
	if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		window_mode_option_button.selected = 0
	elif (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
		window_mode_option_button.selected = 1

func _on_resolutions_option_button_item_selected(index: int) -> void:
	var key = resolutions_option_button.get_item_text(index)
	get_window().set_size(resolutions[key])
	center_window()
	print(str(get_window().size.x, "x", get_window().size.y))
	
func center_window() -> void:
	# Center window after resolution change
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)

func add_window_modes() -> void:
	# Add items inside window mode option button
	for i in window_modes:
		window_mode_option_button.add_item(i)

func _on_window_mode_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
