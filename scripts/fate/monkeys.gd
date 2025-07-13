extends Control
var fate_card_node
var fate_card
var players 
var target
var char1
var char2

func _ready() -> void:
	players=$"../players"
@rpc("any_peer","call_local")
func player_select(player):
	target=players.get_node(player)
	
	if target.inventory.size()==0:
		fate_card_node=get_parent().get_node("fate_cards").get_node(fate_card)
		var monkeys=0
		for char in players.get_children():
			if player.monkeyed==true:
				monkeys+=1
		if monkeys==1:
			fate_card_node.get_node("effect").resolved.rpc_id(1)
		target.monkeyed=false
		if $"Card Choice".visible == false:
			self.queue_free()
		else:
			$"Player Choice".hide()
	var amount_of_players=0
	var target_location = players.get_node(player).current_location
	var target_location_id = GameManager.const_locations.find(target_location)
	for char in players.get_children():
		amount_of_players+=1
	for char in players.get_children():
		if char.current_location==GameManager.const_locations[target_location_id+1]:
			$"Player Choice/HBoxContainer/Button2".text = char.character_name
			char2=char
		elif(amount_of_players-1==target_location_id&&char.current_location=="Beach"):
			$"Player Choice/HBoxContainer/Button2".text = char.character_name
			char2=char
		if char.current_location==GameManager.const_locations[target_location_id-1]:
			$"Player Choice/HBoxContainer/Button".text = char.character_name
			char1=char
		elif (target_location=="Beach"&&char.current_location==GameManager.const_locations[amount_of_players-1]):
			$"Player Choice/HBoxContainer/Button".text = char.character_name
			char1=char
	$"Player Choice".show()


func _on_char1_chosen() -> void:
	MenuClick.play()
	send_a_card_choice(char1)
	


func _on_char2_chosen() -> void:
	MenuClick.play()
	send_a_card_choice(char2)
	
	
func send_a_card_choice(char) -> void:
	fate_card_node=get_parent().get_node("fate_cards").get_node(fate_card)
	fate_card_node.get_node("effect").spawn_card_select.rpc_id(char.player_id,target.name)
	if $"Card Choice".visible == false:
		self.queue_free()
	else:
		$"Player Choice".hide()


func add_cards(player):
	target=players.get_node(player)
	var item_scene = preload("res://scenes/items/show_item_card.tscn")
	for item in target.inventory:
		var control_node= Control.new()
		control_node.name=item
		$"Card Choice/HBoxContainer".add_child(control_node)
		var item_card = item_scene.instantiate()
		item_card.name=item
		item_card.scale=Vector2(0.5,0.5)
		$"Card Choice/HBoxContainer".get_node(item).add_child(item_card)
		item_card=$"Card Choice/HBoxContainer".get_node(item).get_node(item)
		if target.inventory_activated.has(item):item_card.card_name=item;item_card.change_texture(item)
		else:item_card.card_name="closed";item_card.change_texture("closed")
		item_card.make_selecteble()
		
		


func _take_cards_pressed() -> void:
	MenuClick.play()
	target=players.get_node(str(target))
	var items=[]
	for item in $"Card Choice/HBoxContainer".get_children():
		if item.get_node(str(item.name)).get_node("CheckBox").button_pressed==true:
			items.append(str(item.name))
	if items.size()==1:
		CardManager.delete_card.rpc_id(target.player_id,items[0],target,target.get_path())
		fate_card_node=get_parent().get_node("fate_cards").get_node(fate_card)
		var monkeys=0
		for player in players.get_children():
			if player.monkeyed==true:
				monkeys+=1
		if monkeys==1:
			fate_card_node.get_node("effect").resolved.rpc_id(1)
		target.monkeyed=false
		self.queue_free()
	else:
		$"Card Choice/Label".text="Select only 1 card"
