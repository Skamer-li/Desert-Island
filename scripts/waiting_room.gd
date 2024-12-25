extends Control

@onready var start_button = $Panel/start_button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (MultiplayerManager.status == "Host"):
		MultiplayerManager.become_host()
		start_button.visible = true
	elif (MultiplayerManager.status == "Client"):
		MultiplayerManager.join()
		start_button.visible = false

@rpc("any_peer", "call_local")
func start_game() -> void:
	var scene = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_start_button_pressed() -> void:
	start_game.rpc()
	
