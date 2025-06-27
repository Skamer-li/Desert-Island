extends Node2D
@export var spotted_ships=0
signal lookout_resolved
var torches=0
var board=0
var ships=0
func _ready() -> void:
	self.hide()

func lookout(fate_deck,signal_fire):
	var symbols=[]
	for token in signal_fire+1:
		var symbol=fate_deck[token].get_slice("_",3)
		show_card.rpc(fate_deck[token],symbol)
		symbols.append(symbol)
		GameManager.fate_deck_discard.append(fate_deck[token])
		symbol_update.rpc(symbol)
		$wait_time.start()
		await $wait_time.timeout
		remove_card.rpc()
	for card in GameManager.fate_deck_discard.size():
		GameManager.fate_deck.pop_front()
	resolve.rpc(symbols)
	print(symbols)

@rpc("any_peer","call_local")
func show_card(card,symbol):
	self.show()
	var card_scene = preload("res://scenes/fate/base_fate_card.tscn")
	var scene = card_scene.instantiate()
	self.add_child(scene)
	get_node("BaseFateCard").scale=Vector2(2,2)
	get_node("BaseFateCard").position.x=865.875+(188.25/2)
	get_node("BaseFateCard").position.y=406.75+(266.5/2)
	get_node("BaseFateCard").set_properties(card)
	get_node("BaseFateCard").show()
	$"../../sounds/draw_card".play()
	await $"../../sounds/draw_card".finished
@rpc("any_peer","call_local")
func remove_card():
	for card in $card.get_children():
		card.queue_free()
@rpc("any_peer","call_local")
func symbol_update(symbol):
	match symbol:
		"torch.png":torches+=1
		"boards.png":board+=1
		"ship.png":ships+=1
	$Boards/Label.text=str(board)
	$Torch/Label.text=str(torches)
	$Ship/Label.text=str(ships)
@rpc("any_peer","call_local")
func resolve(symbols):
	if "torch.png" in symbols && symbols.has("ship.png")==false:
		$"../..".signal_fire=0
		$"../..".fire_update.rpc()
		print("burn")
	elif "torch.png" in symbols && "ship.png" in symbols && "boards.png" in symbols:
		$"../..".signal_fire=0
		$"../..".fire_update.rpc()
		spotted_ships+=1
		print("Ship spotted")
	board=0
	torches=0
	ships=0
	self.hide()
	lookout_resolved.emit()
