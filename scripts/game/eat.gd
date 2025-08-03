extends Control

signal hunger_finished

var player_path

func _ready() -> void:
	self.hide()

func eating_init() -> void:
	for player in $"../../players".get_children():
		if player.is_dead==false:
			var char_path=player.get_path()
			GameManager.change_eating_status.rpc_id(1,true,char_path)
			eating_phase.rpc_id(player.player_id,char_path)
		
@rpc("any_peer","call_local")
func eating_phase(char_path) -> void:
	player_path=char_path
	var player_node=get_node(player_path)
	var food_decrease=player_node.base_strength
	#if player_node.food_amount<food_decrease:
		#GameManager.change_eating_status.rpc_id(1,false,player_path)
		#_on_no_pressed()
	#else:	
		#self.show()
		
	self.show()
		
func _on_yes_pressed() -> void:
	var players_eating=0
	for player in $"../../players".get_children():
		if player.eating==true:
			players_eating+=1
	
	var player_node=get_node(player_path)	
	var food_decrease=player_node.base_strength + player_node.hunger_food_amount
	
	if (player_node.current_location == "Jungle"):
		food_decrease -= 3
		
	if (food_decrease < 0):
		food_decrease = 0
		
	if player_node.food_amount>=food_decrease:
		GameManager.decrease_food_amount.rpc_id(1,player_path,food_decrease)
	else:
		_on_no_pressed()
		
	if players_eating==1:
		send_signal.rpc()
	else:
		GameManager.change_eating_status.rpc_id(1,false,player_path)
	self.hide()
	
func _on_no_pressed() -> void:
	var players_eating=0
	for player in $"../../players".get_children():
		if player.eating==true:
			players_eating+=1
		
	GameManager.deal_damage.rpc_id(1,player_path)
		
	if players_eating==1:
		send_signal.rpc()
	else:
		GameManager.change_eating_status.rpc_id(1,false,player_path)
	self.hide()
	
@rpc("any_peer","call_local")
func send_signal() -> void:
	hunger_finished.emit()
