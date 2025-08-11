extends Node2D

@onready var basic_actions = $actions/basic_actions

@export var fate_card_value = 0
@export var signal_fire = 0

var finished_turn = []
var current_turn = 0

var current_location = "Beach"
var current_player_id = 0
var current_character_name = "Name"
var cards_dealed = false
var fate_dealed = 0
var fate_resolved = 0
var game_end = false
var fire_radius=87.5/2
var ships=0
var game_ended =0


@rpc ("any_peer")
func game_loop():
	while(!game_end):
		current_turn += 1
		
		match(current_turn):
			1:
				current_location = "Beach"
				fate_resolved=0
				fire_update()
			2:
				current_location = "Jungle"
			3:
				current_location = "Swamp"
			4:
				current_location = "Spring"
			5:
				current_location = "Hill"
			6:
				current_location = "Cave"
			_:
				$actions/lookout.start_lookout()
				await $actions/lookout.lookout_resolved
				GameManager.call_ready_check.rpc_id(1)
				await GameManager.ready_check_done
				if fate_resolved==0&&multiplayer.is_server()&&game_ended==0: fate_resolve()
				await $fate_cards.fate_card_resolved
				deleting_fate.rpc()
				GameManager.call_ready_check.rpc_id(1)
				await GameManager.ready_check_done
				$actions/eat.eating_init()
				await $actions/eat.hunger_finished
				current_turn = 0
				cards_dealed = false
				fate_dealed = 0
				finished_turn.clear()
				continue
		
		current_player_id = player_id_on_location(current_location)
		current_character_name = character_name_on_location(current_location)
		
		if (finished_turn.has(current_character_name)):
			continue
		
		match (current_player_id):
			0:
				continue
			1:
				#GameManager.items.size() >= characters_alive()
				if (!cards_dealed && GameManager.items.size() > 0):
					$actions/cards_dealing.set_cards_to_deal(GameManager.items)
				else:
					CardManager.shuffle_discarded_fate(2)
					$actions/fate_dealing.drawing_fate_cards(GameManager.fate_deck)
					#basic_actions.show_actions(current_character_name, fate_card_value)
			_:
				if (!cards_dealed && GameManager.items.size() > 0):
					$actions/cards_dealing.set_cards_to_deal.rpc_id(current_player_id, GameManager.items)
				else:
					CardManager.shuffle_discarded_fate.rpc(2)
					$actions/fate_dealing.drawing_fate_cards.rpc_id(current_player_id, GameManager.fate_deck)
					#basic_actions.show_actions.rpc_id(current_player_id, current_character_name, fate_card_value)
		
		finished_turn.append(current_character_name)
		return
	
func player_id_on_location(location: String) -> int:
	for player in $players.get_children():
		if (player.current_location == location && player.is_dead == false):
			return player.player_id
	return 0
	
func character_name_on_location(location: String) -> String:
	for character in $players.get_children():
		if (character.current_location == location):
			return character.character_name
	return "Name"
	
func characters_alive() -> int:
	var char_count = 0
	
	for character in $players.get_children():
		if (character.is_dead == false):
			char_count += 1
			
	return char_count

func swamp_food_lose():
	if (current_location == "Swamp"):
		var current_character = $players.get_node(current_character_name)
		if (current_character.food_amount != 0):
			current_character.food_amount -= 1

@rpc ("any_peer")
func show_actions_as_host():
	basic_actions.show_actions.rpc_id(current_player_id, current_character_name, fate_card_value)

@rpc ("any_peer")
func draw_fate_as_host():
	CardManager.shuffle_discarded_fate.rpc(2)
	$actions/fate_dealing.drawing_fate_cards.rpc_id(current_player_id, GameManager.fate_deck)
	
@rpc ("any_peer")
func cards_dealed_info() -> void:
	cards_dealed = true

@rpc ("any_peer")
func fate_dealed_info() -> void:
	fate_dealed +=1 

func fate_resolve():
	var fate_tokens=[]
	var targets=[]
	
	for player in $players.get_children():
		if (!player.is_dead):
			fate_tokens.append(player.fate_amount)
			
	for player in $players.get_children():
		if (player.fate_amount>= fate_tokens.max()&& player.is_dead==false):
			targets.append(player.character_name)
			
	var fate = []
	var fate_count=[]
	var current_locations = []
	
	for location in GameManager.const_locations:
		for fate_card in $fate_cards.get_children():
			if (fate_card.current_location == location):
				if (!current_locations.has(location)):
					current_locations.append(location)
					
				fate.append(fate_card.card_name)
				
	for fate_card in fate:
		fate_count.append(fate.count(fate_card))
		
	print($fate_cards.get_node(current_locations[fate_count.find(fate_count.max())] + "_fate").card_fullname)
	print(targets)
	
	$fate_cards.get_node(current_locations[fate_count.find(fate_count.max())] + "_fate").get_node("effect").fate_activated(targets)

	fate_resolved=1
	
@rpc("any_peer","call_local")
func deleting_fate():
	for fate_card in $fate_cards.get_children():
		GameManager.fate_deck.append(fate_card.card_fullname)
		fate_card.queue_free()
	for player in $players.get_children():
		player.char_fate = 0
	for location in $locations.get_children():
		location.fate_token_amount = 0
	GameManager.fate_update.rpc()

func fire_update():
	$SignalFireToken/fate_tokens_fire.fate_token_placing.rpc(signal_fire,fire_radius)
	print(signal_fire)

func end_game():
	game_end=true
	for character in $players.get_children():
		var character_name = character.character_name
		var enemy_name = character.enemy_name
		var friend_name = character.friend_name
		
		var id = character.player_id  
		var player = character.player_name
		
		#Own Survival Points
		if (character.is_dead == false):
			GameScoreVar.give_points(character_name, character.survival_points,player)

		#Friend Survival Points
		if $players.get_node(friend_name).is_dead==false:
			GameScoreVar.give_points(character_name, $players.get_node(friend_name).survival_points,player)

		#Enemy Survival Points
		if $players.get_node(enemy_name).is_dead==true&&enemy_name!=character_name:
			GameScoreVar.give_points(character_name, $players.get_node(enemy_name).base_strength,player)
			
		#Psychopath Points
		if enemy_name==character_name:
			var characters_dead=$players.get_children().size()-characters_alive()
			GameScoreVar.give_points(character_name, 2*characters_dead,player)
			if $players.get_node(friend_name).is_dead == true:
				GameScoreVar.give_points(character_name, -2,player)
		#Items
		for item in character.get_node("Hand").get_children():
			if item.name!="DebugShape":GameScoreVar.give_points(character_name, item.value,player)
	print(GameScoreVar.game_score)
	show_game_score.rpc()
	game_ended=1
@rpc("any_peer","call_local")
func show_game_score():
	#await $sounds/effects.finished
	get_tree().change_scene_to_file("res://scenes/game_score.tscn")
	self.queue_free()
	
func _on_shuffle_players_are_ready() -> void:
	game_loop()

func _on_cards_dealing_cards_dealing_finished() -> void:
	if multiplayer.is_server():
		cards_dealed_info()
		CardManager.shuffle_discarded_fate(2)
		$actions/fate_dealing.drawing_fate_cards(GameManager.fate_deck)
	else:
		cards_dealed_info.rpc_id(1)
		draw_fate_as_host.rpc_id(1)

func _on_basic_actions_action_finished() -> void:
	swamp_food_lose()
	fire_update()
	game_loop()

func _on_fate_dealing_fate_dealing_finished() -> void:
	if multiplayer.is_server():
		fate_dealed_info()
		basic_actions.show_actions(current_character_name, fate_card_value)
	else:
		fate_dealed_info.rpc_id(1)
		show_actions_as_host.rpc_id(1)

func _on_lookout_ship_spotted() -> void:
	if multiplayer.is_server():
		ships+=1
		
		$ships.create_ship.rpc(ships)
		if ships == 4:
			end_game()
		
func decrement_turn():
	current_turn -= 1
