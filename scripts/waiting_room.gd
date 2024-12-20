extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (MultiplayerManager.status == "Host"):
		MultiplayerManager.become_host()
	elif (MultiplayerManager.status == "Client"):
		MultiplayerManager.join()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
