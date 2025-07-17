extends Node

var divide_food_node
var player

var food_division=[
	{"Player Left":0},
	{"Player Right":0}
]

func connect_food_division():
	divide_food_node=self.get_node("divide_food")
	divide_food_node.division_finished.connect(_send_food_division)
	
func _send_food_division(left,right):
	player=divide_food_node.sender
	write_down_food_division.rpc_id(1,player,left,right)
	var rats=0
	for char in $"../../players".get_children():
		if char.ratted==true:
			rats+=1
	if rats!=1:
		GameManager.remove_add_rats.rpc_id(1,false,$"../../players".get_node(str(player)).get_path())
	else:
		draw_fate_card_as_host.rpc_id(1)

#Call only as host
@rpc("any_peer","call_local")	
func write_down_food_division(char,left,right):
	food_division[0][char]=left
	food_division[1][char]=right

@rpc("any_peer","call_local")
func draw_fate_card_as_host():
	draw_fate_card.rpc(GameManager.fate_deck[0])
	GameManager.fate_deck_discard.append(GameManager.fate_deck.pop_front())

@rpc("any_peer","call_local")
func draw_fate_card(card):
	var card_scene = preload("res://scenes/fate/base_fate_card.tscn")
	var scene = card_scene.instantiate()
	var x_res=1920
	var y_res=1080
	var card_width=753/2
	var card_height=1066/2
	scene.scale=Vector2(2,2)
	scene.position=Vector2((x_res/2),(y_res/2))
	scene.show()
	self.add_child(scene)
	get_node("BaseFateCard").set_properties(card)
	$"../../sounds/draw_card".play()
	await get_tree().create_timer(2).timeout
	get_node("BaseFateCard").queue_free()
	
	if (multiplayer.is_server()):
		remove_food.rpc_id(1,get_node("BaseFateCard").number)

@rpc("any_peer","call_local")
func remove_food(number):
	if number%2==0:
		for char in $"../../players".get_children():
			if char.food_amount!=0:
				var food_amount = int(food_division[0][str(char.name)])
				GameManager.decrease_food_amount(char.get_path(),food_amount)
	else:
		for char in $"../../players".get_children():
			if char.food_amount!=0:
				var food_amount = int(food_division[1][str(char.name)])
				GameManager.decrease_food_amount(char.get_path(),food_amount)
	$"../../fate_cards".fate_card_resolve.rpc()
