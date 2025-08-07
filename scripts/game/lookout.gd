extends Control

signal lookout_resolved
signal ship_spotted

var player_id
var players_node
var game_node
var players_not_looking=0

@export var symbols = {"Torches":0,"Boards":0,"Ships":0}:
	set = _set_symbols

func _ready() -> void:
	players_node=$"../../players"
	game_node=$"../.."

func _set_symbols(dict: Dictionary):
	$symbols/torches.text=str(dict["Torches"])
	$symbols/boards.text=str(dict["Boards"])
	$symbols/ships.text=str(dict["Ships"])	
	
@rpc("any_peer","call_local")
func start_lookout() -> void:
	game_node.signal_fire+=1
	game_node.fire_update()
	for player in players_node.get_children():
		if !player.is_dead:
			look_for_ship.rpc_id(player.player_id,player.player_id)

@rpc("any_peer","call_local")
func look_for_ship(id) -> void:
	player_id=id
	$look_for_ship.show()


func _on_no_pressed() -> void:
	MenuClick.play()
	$look_for_ship.hide()
	count_not_looking_players.rpc_id(1)

func _on_yes_pressed() -> void: 
	MenuClick.play()
	hide_for_everyone.rpc()
	for player in players_node.get_children():
		if player.player_id==player_id:
			GameManager.send_message.rpc(player.name+"decided to look for the ship")
	lookout.rpc_id(1)
	
@rpc("any_peer","call_local")
func count_not_looking_players() -> void:
	players_not_looking+=1
	if players_not_looking == game_node.characters_alive():
		lookout_resolved.emit()


@rpc("any_peer","call_local")
func hide_for_everyone() -> void:
	$look_for_ship.hide()

@rpc("any_peer","call_local")
func lookout() -> void:
	var tokens = game_node.signal_fire
	if tokens > (GameManager.fate_deck.size()+GameManager.fate_deck_discard.size()):
		tokens=GameManager.fate_deck.size()+GameManager.fate_deck_discard.size()
	CardManager.shuffle_discarded_fate(tokens)
	for token in tokens:
		$"../../sounds/draw_card".play()
		var card = GameManager.fate_deck[token]
		show_card.rpc(card)
		var symbol = $card_container/card/BaseFateCard.resource
		add_symbol(symbol)
		await get_tree().create_timer(1).timeout
	hide_card.rpc()
	resolve()

@rpc("any_peer","call_local")
func show_card(card: String) -> void:
	$symbols.show()
	$card_container.show()
	$card_container/card/BaseFateCard.set_properties(card)
	
func add_symbol(symbol):
	match symbol:
		"torch.png": symbols["Torches"]+=1
		"boards.png": symbols["Boards"]+=1
		"ship.png": symbols["Ships"]+=1

@rpc("any_peer","call_local")
func hide_card():
	$card_container.hide()
	$symbols.hide()
	
func resolve():
	if symbols["Torches"]>=1&&symbols["Boards"]>=1&&symbols["Ships"]>=1:
		game_node.signal_fire=0
		game_node.fire_update()
		$"../../sounds".ship_horn.rpc()
		await $"../../sounds/effects".finished
		ship_spotted.emit()
	elif symbols["Torches"]>=1&&symbols["Boards"]>=1:
		game_node.fire_update()
		game_node.signal_fire=0
	lookout_resolved.emit()
	symbols["Torches"]=0
	symbols["Boards"]=0
	symbols["Ships"]=0
