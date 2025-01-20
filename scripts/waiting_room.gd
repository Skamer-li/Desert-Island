extends Control

@onready var start_button = $Panel/start_button
@onready var error_background = $Panel/error_background
var players_connected

func _ready() -> void:
	start_button.hide()
	error_background.hide()
	if (MultiplayerManager.status == "Host"):
		MultiplayerManager.become_host()
	elif (MultiplayerManager.status == "Client"):
		MultiplayerManager.join()
			
func _process(delta: float) -> void:
	if MultiplayerManager.peers_connected >= 3:
		start_button.show()
	else:
		start_button.hide()
	
	if(MultiplayerManager.failed_id != -1):
		show_error.rpc_id(MultiplayerManager.failed_id)
		MultiplayerManager.failed_id = -1

@rpc("any_peer", "call_local")
func start_game() -> void:
	MultiplayerManager.is_in_game = 1
	var scene = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_start_button_pressed() -> void:
	start_game.rpc()

func _on_ok_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
@rpc
func show_error() -> void:
	error_background.show()
