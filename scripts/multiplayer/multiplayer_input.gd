extends MultiplayerSynchronizer

#This script detects input and changes of client and synchronizes it with host
@export var player_name = "Name"

var count = 0

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	player_name = MultiplayerManager.user_name
	if is_multiplayer_authority():
			send_player_name.rpc_id(1, player_name)


@rpc("authority", "call_local")
func send_player_name(name: String):
	if multiplayer.is_server():
		GameManager.players_name.append(name)
