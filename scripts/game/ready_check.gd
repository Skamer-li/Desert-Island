extends Control

var player_id


func init_id(id):
	player_id=id
	
func _on_ready_button_pressed() -> void:
	var players = get_node("/root/game/players")
	$bg/Sam.region_rect=Rect2(0, 0, 0, 0)
	$bg/Sam.texture=load("res://sprites/characters/sam2.jpg")
	$bg/ready_button.disabled=true
	GameManager.ready_recieved.rpc_id(1)
	for player in players.get_children():
		if player.player_id==player_id:
			GameManager.send_message.rpc(str(player.character_name)+" is ready")
	
