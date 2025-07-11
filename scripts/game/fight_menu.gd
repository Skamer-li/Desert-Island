extends Sprite2D

var my_char
var side1
var side2

var side1_chars = []
var side2_chars = []

var side1_str = 0
var side2_str = 0

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
	var side1_node = $"../../players".get_node(side1_char)
	var side2_node = $"../../players".get_node(side2_char)
	
	$text/side_1_main/interface/side_1.text = side1_char
	$text/side_1_main/player_1/name.text = side1_char
	$text/side_1_main/player_1/power.text = str(side1_node.fight_strength)
	$text/side_1_main/interface/total_1_value.text = str(side1_node.fight_strength + $"../..".fate_card_value)
	$text/side_1_main/interface/card/power.text = str($"../..".fate_card_value)
	
	side1_str = side1_node.fight_strength + $"../..".fate_card_value
	side1_chars.append(side1_char)
	
	$text/side_1_main2/interface/side_1.text = side2_char
	$text/side_1_main2/player_1/name.text = side2_char
	$text/side_1_main2/player_1/power.text = str(side2_node.fight_strength)
	$text/side_1_main2/interface/total_1_value.text = str(side2_node.fight_strength)
	
	side2_str = side2_node.fight_strength
	side2_chars.append(side2_char)

@rpc ("any_peer", "call_local")
func add_char_to_fight(side, character):
	var char_node = $"../../players".get_node(character)
	var second_part = "/name"
	var second_part2 = "/power"
	var sum 
	var sum2
	
	#changing text in places that show character's power
	if (side):
		var first_part = "text/side_1_main/player_"
		
		sum = first_part + str(side1_chars.size() + 1) + second_part
		sum2 = first_part + str(side1_chars.size() + 1) + second_part2
		
		get_node(sum).text = character
		get_node(sum2).text = str(char_node.fight_strength)
		get_node(first_part + str(side1_chars.size() + 1)).show()
		
		side1_str += char_node.fight_strength
		side1_chars.append(character)
		
		$text/side_1_main/interface/total_1_value.text = str(side1_str)
	else:
		var first_part = "text/side_1_main2/player_"
		
		sum = first_part + str(side2_chars.size() + 1) + second_part
		sum2 = first_part + str(side2_chars.size() + 1) + second_part2
		
		get_node(sum).text = character
		get_node(sum2).text = str(char_node.fight_strength)
		get_node(first_part + str(side2_chars.size() + 1)).show()
		
		side2_str += char_node.fight_strength
		side2_chars.append(character)
		
		$text/side_1_main2/interface/total_1_value.text = str(side2_str)
		
@rpc ("any_peer", "call_local")
func refresh_data():
	#refreshing data after drawing another weapon
	var full_str_1 = $"../..".fate_card_value
	var full_str_2 = 0
	
	#check for side1
	for char in side1_chars:
		var char_node = $"../../players".get_node(char)
		var first_part = "text/side_1_main/player_"
		var second_part = "/power"
		var sum = first_part + str(side1_chars.find(char, 0) + 1) + second_part
		
		get_node(sum).text = str(char_node.fight_strength)
		
		full_str_1 += char_node.fight_strength
	
	$text/side_1_main/interface/total_1_value.text = str(full_str_1)
	
	#check for side2
	for char in side2_chars:
		var char_node = $"../../players".get_node(char)
		var first_part = "text/side_1_main2/player_"
		var second_part = "/power"
		var sum = first_part + str(side2_chars.find(char, 0) + 1) + second_part
		
		get_node(sum).text = str(char_node.fight_strength)
		
		full_str_2 += char_node.fight_strength
	
	$text/side_1_main2/interface/total_1_value.text = str(full_str_2)

func trade_block(block):
	for character in $"../../players".get_children():
		character.get_node("TradeButton").disabled = block

@rpc ("any_peer", "call_local")
func ready_check():
	var sender_node = $"../../players".get_node(side1)
	var winner
	
	is_ready += 1
	
	if (is_ready >= 2):
		request_host_fate_card.rpc_id(1)
		
		$"../Timer".start()
		await $"../Timer".timeout
		
		remove_card.rpc()
		
		if (side1_str > side2_str):
			$"..".deal_damage.rpc_id(1, side2_chars)
			$".."._on_accept_pressed()
			winner = side1
		else:
			$"..".deal_damage.rpc_id(1, side1_chars)
			winner = side2
		
		delete_blunderbuss()
		
		finish_fight.rpc(winner)
		
@rpc ("any_peer", "call_local")
func request_host_fate_card():
	#add CARDMANAGER change
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
	get_node("BaseFateCard").queue_free()
	
@rpc ("any_peer", "call_local")
func side_2_fate(value):
	$text/side_1_main2/interface/card/power.text = str(value)
	side2_str += value
	$text/side_1_main2/interface/total_1_value.text = str(side2_str)

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
	
	$ready_button.disabled = false
	$winner.hide()
	$fight_button_side1.hide()
	$fight_button_side2.hide()
	$"../menu_button".hide()
	
	#hide all players added to fight previously 
	for node in $text/side_1_main.get_children():
		if (node.name != "interface" && node.name != "player_1"):
			node.hide()
	
	for node in $text/side_1_main2.get_children():
		if (node.name != "interface" && node.name != "player_1"):
			node.hide()
			
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
		
