extends Control

@onready var start_button = $Panel/start_button
var players_connected
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.hide()
	if (MultiplayerManager.status == "Host"):
		MultiplayerManager.become_host()
	elif (MultiplayerManager.status == "Client"):
		MultiplayerManager.join()
			
func _process(delta: float) -> void:
	if MultiplayerManager.peers_connected >= 3:
		start_button.show()

@rpc("any_peer", "call_local")
func start_game() -> void:
	var scene = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_start_button_pressed() -> void:
	start_game.rpc()
