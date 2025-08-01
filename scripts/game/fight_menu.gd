extends Sprite2D

var my_char
@export var side1 = ""
@export var side2 = ""

@export var side1_chars = []
@export var side2_chars = []

@export var side1_str = 0
@export var side2_str = 0

var player_fight_scene = preload("res://scenes/player_in_fight.tscn")

var is_side
var is_ready = 0

@rpc ("any_peer", "call_local")
func show_fight_table(character, side1_char, side2_char, is_side_char):
	my_char = character
	side1 = side1_char
	side2 = side2_char
	is_side = is_side_char
	
	if (is_side_char):
		$ready_button.show()
	else:
		$fight_button_side1.show()
		$fight_button_side2.show()
		
	$"../menu_button".show()
	
	set_sides(side1_char, side2_char)
	trade_block(true)
	
	$".".show()
	
func set_sides(side1_char, side2_char):
	GameManager.is_fight = true
	
	#filling text on the fight menu	
	$text/side_1_main/interface/side_1.text = side1_char
	side1_str += $"../..".fate_card_value
	add_char_to_fight(true, side1_char)
	$text/side_1_main/interface/card/power.text = str($"../..".fate_card_value)
	
	$text/side_2_main/interface/side_1.text = side2_char
	add_char_to_fight(false, side2_char)

@rpc ("any_peer", "call_local")
func add_char_to_fight(side, character):
	var char_node = $"../../players".get_node(character)
	
	var char_instance = player_fight_scene.instantiate()
	char_instance.set_properties(character, char_node.fight_strength)
	
	#changing text in places that show character's power
	if (side):
		$text/side_1_main/VBoxContainer.add_child(char_instance)
		
		side1_str += char_node.fight_strength
		side1_chars.append(character)
		
		$text/side_1_main/interface/total_1_value.text = str(side1_str)
	else:
		$text/side_2_main/VBoxContainer.add_child(char_instance)
		
		side2_str += char_node.fight_strength
		side2_chars.append(character)
		
		$text/side_2_main/interface/total_1_value.text = str(side2_str)

@rpc ("any_peer", "call_local")
func delete_char_from_fight(character):
	if (side1_chars.has(character)):
		side1_chars.erase(character)
		$text/side_1_main/VBoxContainer.get_node(character).queue_free()
	
	if (side2_chars.has(character)):
		side2_chars.erase(character)
		$text/side_2_main/VBoxContainer.get_node(character).queue_free()
		
	refresh_data()
				
@rpc ("any_peer", "call_local")
func refresh_data():
	#refreshing data after drawing another weapon
	var full_str_1 = $"../..".fate_card_value
	var full_str_2 = 0
	
	#check for side1
	for char in side1_chars:
		var char_node = $"../../players".get_node(char)
		
		$text/side_1_main/VBoxContainer.get_node(char).set_properties(char_node.character_name, char_node.fight_strength)
		
		full_str_1 += char_node.fight_strength
		
	side1_str = full_str_1
	$text/side_1_main/interface/total_1_value.text = str(full_str_1)
	
	#check for side2
	for char in side2_chars:
		var char_node = $"../../players".get_node(char)
		
		$text/side_2_main/VBoxContainer.get_node(char).set_properties(char_node.character_name, char_node.fight_strength)
		
		full_str_2 += char_node.fight_strength
	
	side2_str = full_str_2
	$text/side_2_main/interface/total_1_value.text = str(full_str_2)

func trade_block(block):
	for character in $"../../players".get_children():
		character.get_node("TradeButton").disabled = block

@rpc ("any_peer", "call_local")
func ready_check():
	var sender_node = $"../../players".get_node(side1)
	var winner
	
	is_ready += 1
	
	if (is_ready >= 2):
		block_fight_buttons.rpc()
		
		if (side1_chars.has("Cherpack") || side2_chars.has("Cherpack")):
			cherpack_action.rpc_id($"../../players".get_node("Cherpack").player_id)
		else:
			fight_calculations()

@rpc ("any_peer", "call_local")
func cherpack_action():
	$"../escape_fight_message".show()
	
@rpc ("any_peer", "call_local")
func block_fight_buttons():
	$fight_button_side1.disabled = true
	$fight_button_side2.disabled = true

@rpc ("any_peer", "call_local")
func fight_calculations():
	var winner
	
	request_host_fate_card.rpc_id(1)
		
	$"../Timer".start()
	await $"../Timer".timeout
	
	remove_card.rpc()
	
	if (side1_str > side2_str):
		print(side2_chars)
		for character in side2_chars:
			var current_path = $"../../players".get_node(character).get_path()
			GameManager.deal_damage.rpc_id(1, current_path)
		$".."._on_accept_pressed()
		winner = side1
	else:
		for character in side1_chars:
			var current_path = $"../../players".get_node(character).get_path()
			GameManager.deal_damage.rpc_id(1, current_path)
		winner = side2
	
	delete_blunderbuss()
	
	finish_fight.rpc(winner)

@rpc ("any_peer", "call_local")
func request_host_fate_card():
	CardManager.shuffle_discarded_fate.rpc(1)
	draw_fate.rpc(GameManager.fate_deck[0])
	side_2_fate.rpc(get_node("BaseFateCard").number)
	GameManager.fate_deck_discard.append(GameManager.fate_deck.pop_front())

@rpc ("any_peer", "call_local")
func draw_fate(card):
	var card_scene = preload("res://scenes/fate/base_fate_card.tscn")
	var scene = card_scene.instantiate()
	self.add_child(scene)
	get_node("BaseFateCard").scale=Vector2(2,2)
	get_node("BaseFateCard").position.x=0
	get_node("BaseFateCard").position.y=0
	get_node("BaseFateCard").set_properties(card)
	get_node("BaseFateCard").show()
	$"../../sounds/draw_card".play()
	await $"../../sounds/draw_card".finished
	
@rpc ("any_peer", "call_local")
func remove_card():
	var node = get_node_or_null("BaseFateCard")
	if (node != null):
		node.queue_free()
	
@rpc ("any_peer", "call_local")
func side_2_fate(value):
	$text/side_2_main/interface/card/power.text = str(value)
	side2_str += value
	$text/side_2_main/interface/total_1_value.text = str(side2_str)

@rpc ("any_peer", "call_local")
func finish_fight(winner):	
	is_ready = 0
	side1_chars.clear()
	side2_chars.clear()
	side1_str = 0
	side2_str = 0
	
	$winner.text = "The winner is " + winner
	$winner.show()
		
	$"../Timer".start()
	await $"../Timer".timeout
	
	$text/side_2_main/interface/card/power.text = "0"
	$ready_button.hide()
	$ready_button.disabled = false
	$winner.hide()
	$fight_button_side1.hide()
	$fight_button_side2.hide()
	$fight_button_side1.disabled = false
	$fight_button_side2.disabled = false
	$"../menu_button".hide()
	
	#hide all players added to fight previously 
	for node in $text/side_1_main/VBoxContainer.get_children():
		node.queue_free()
	
	for node in $text/side_2_main/VBoxContainer.get_children():
		node.queue_free()
			
	#enable buttons for basic actions
	if (my_char == side1 && winner == side2):
		$"../../actions/basic_actions".disable_buttons(true)
	
	trade_block(false)
	self.hide()

@rpc ("any_peer", "call_local")
func end_turn_for_sender():
	$"../../actions/basic_actions".disable_buttons(true)

@rpc ("any_peer", "call_local")
func delete_blunderbuss():
	for character in $"../../players".get_children():
		if ((side1_chars.has(character.character_name) || side2_chars.has(character.character_name)) && character.inventory_activated.has("blunderbuss")):
			CardManager.delete_card.rpc_id(character.player_id, "blunderbuss", character.character_name, character.get_path())

func _on_fight_button_side_1_pressed() -> void:
	add_char_to_fight.rpc(true, my_char)
	GameManager.increment_fate.rpc_id(1, $"../../players".get_node(my_char).get_path())
	$fight_button_side1.disabled = true
	$fight_button_side2.disabled = true

func _on_fight_button_side_2_pressed() -> void:
	add_char_to_fight.rpc(false, my_char)
	GameManager.increment_fate.rpc_id(1, $"../../players".get_node(my_char).get_path())
	$fight_button_side1.disabled = true
	$fight_button_side2.disabled = true

func _on_menu_button_pressed() -> void:
	self.show()

func _on_ready_button_pressed() -> void:
	var reciever_node = $"../../players".get_node(side2)
	$ready_button.disabled = true
	ready_check.rpc_id(reciever_node.player_id)
		
