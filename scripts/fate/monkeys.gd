extends Control
var fate_card_node
var fate_card
var players 
var target
var target2
var char1
var char2

func _ready() -> void:
	players=$"../players"
	
@rpc("any_peer","call_local")
func player_select(player):
	target=players.get_node(player)
	if target.inventory.size()==0:
		fate_card_node=get_parent().get_node("fate_cards").get_node(fate_card)
		if $"Card Choice".visible == false:
			self.queue_free()
		else:
			$"Player Choice".hide()
	char2=find_char_on_the_right(str(target))
	
	char1=find_char_on_the_left(str(target))
	if char1=="Balls":
		$"Player Choice/HBoxContainer/Button".hide()
	if char2=="Balls":
		$"Player Choice/HBoxContainer/Button2".hide()
	$"Player Choice/HBoxContainer/Button2".text = char2
	$"Player Choice/HBoxContainer/Button".text = char1
	$"Player Choice".show()



func find_char_on_the_right(target) -> String:
	var char
	var target_location = players.get_node(target).current_location
	var target_location_id = GameManager.const_locations.find(target_location)
	var max_location_id=[]
	for player in players.get_children():
		if !player.is_dead:
			var player_location = player.current_location
			max_location_id.append(GameManager.const_locations.find(player_location))
	max_location_id=max_location_id.max()
	if max_location_id==target_location_id:
		return "Balls"
	for player in players.get_children():
		if GameManager.const_locations.find(player.current_location)==target_location_id+1&&!player.is_dead:
			char=str(player.name)
		elif GameManager.const_locations.find(player.current_location)==target_location_id+1&&player.is_dead:
			char = find_char_on_the_right(str(player.name))
	return char
	
func find_char_on_the_left(target) -> String:
	var char
	var target_location = players.get_node(target).current_location
	var target_location_id = GameManager.const_locations.find(target_location)
	var min_location_id=[]
	for player in players.get_children():
		if !player.is_dead:
			var player_location = player.current_location
			min_location_id.append(GameManager.const_locations.find(player_location))
	min_location_id=min_location_id.min()
	if min_location_id==target_location_id:
		return "Balls"
	for player in players.get_children():
		if GameManager.const_locations.find(player.current_location)==target_location_id-1&&!player.is_dead:
			char=str(player.name)
		elif GameManager.const_locations.find(player.current_location)==target_location_id-1&&player.is_dead:
			char = find_char_on_the_left(str(player.name))
	return char


func _on_char1_chosen() -> void:
	MenuClick.play()
	send_a_card_choice(char1)
	


func _on_char2_chosen() -> void:
	MenuClick.play()
	send_a_card_choice(char2)
	
	
func send_a_card_choice(char) -> void:
	fate_card_node=get_parent().get_node("fate_cards").get_node(fate_card)
	char=players.get_node(str(char))
	fate_card_node.get_node("effect").spawn_card_select.rpc_id(char.player_id,target.name)
	if $"Card Choice".visible == false:
		self.queue_free()
	else:
		$"Player Choice".hide()


func add_cards(player):
	target2=players.get_node(player)
	var item_scene = preload("res://scenes/items/show_item_card.tscn")
	for item in target2.inventory:
		var control_node= Control.new()
		control_node.name=item
		$"Card Choice/HBoxContainer".add_child(control_node)
		var item_card = item_scene.instantiate()
		item_card.name=item
		item_card.scale=Vector2(0.5,0.5)
		$"Card Choice/HBoxContainer".get_node(item).add_child(item_card)
		item_card=$"Card Choice/HBoxContainer".get_node(item).get_node(item)
		if target2.inventory_activated.has(item):item_card.card_name=item;item_card.change_texture(item)
		else:item_card.card_name="closed";item_card.change_texture("closed")
		item_card.make_selecteble()
		
		


func _take_cards_pressed() -> void:
	MenuClick.play()
	target2=players.get_node(str(target2))
	var items=[]
	for item in $"Card Choice/HBoxContainer".get_children():
		if item.get_node(str(item.name)).get_node("CheckBox").button_pressed==true:
			items.append(str(item.name))
	if items.size()==1:
		CardManager.delete_card.rpc_id(target2.player_id,items[0],target2,target2.get_path())
		GameManager.send_message.rpc("Monkeys took " + target + "'s " + items[0])
		fate_card_node=get_parent().get_node("fate_cards").get_node(fate_card)
		fate_card_node.get_node("effect").monkey_business_finished.rpc_id(1)
		self.queue_free()
	else:
		$"Card Choice/Label".text="Select only 1 card"
