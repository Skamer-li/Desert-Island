extends Control
var scores=[]
var game_score
var detailed_init = false
func sort_descending(a, b):
	if a > b:
		return true
	return false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		logged_in_plus_plus()
		for character in GameScoreVar.game_score[0]:
			scores.append(GameScoreVar.game_score[0][character])
		scores.sort_custom(sort_descending)
	else:
		logged_in_plus_plus.rpc_id(1)
		
func _process(delta: float) -> void:
	if multiplayer.is_server()&&GameManager.logged_in==GameManager.players_id.size():
		display_score.rpc(scores,GameScoreVar.game_score)
		GameManager.logged_in=1000
		
@rpc("any_peer","call_local")
func display_score(scores,dic_score):
	game_score=dic_score
	var scene =preload("res://scenes/container_box.tscn")
	var winners=[]
	for characters in game_score[0]:
		if game_score[0][characters]==scores.max():
			winners.append(characters)
	$Panel1/ReferenceRect2/Label.text=(", ".join(winners)+" Won")
	for score in scores:
		var nth_place_holders=[]
		var players=[]
		for characters in game_score[0]:
			if game_score[0][characters]==score:
				nth_place_holders.append(characters)
				players.append(str(game_score[1][characters+" Player"]))
		var box_container=scene.instantiate()
		var box_container2=scene.instantiate()
		var grid=$Panel1/GridContainer
		grid.add_child(box_container)
		grid.get_node("container_box").get_node("Label").text="{}({})".format([", ".join(nth_place_holders)," ,".join(players)], "{}")
		grid.get_node("container_box").name=nth_place_holders[0]
		grid.add_child(box_container2)
		grid.get_node("container_box").get_node("Label").text=str(score)
		grid.get_node("container_box").name=nth_place_holders[0]+"1"

@rpc("any_peer")
func logged_in_plus_plus():
	GameManager.logged_in+=1
func _on_button_pressed() -> void:
	MenuClick.play()
	await MenuClick.finished
	get_tree().quit()


func _on_detailed_score_pressed() -> void:
	$DetailedScore.show()
	$Panel1.hide()
	MenuClick.play()
	init_detailed_game_score()
	
func init_detailed_game_score():
	if !detailed_init:
		detailed_init=true
		var grid=$DetailedScore/GridContainer
		for container in grid.get_children():
			container.get_node("Label").text=str(container.name)
		var scene = preload("res://scenes/container_box.tscn")
		for character in game_score[0]:
			#Character
			var box_container = scene.instantiate()
			box_container.get_node("Label").text=character
			grid.add_child(box_container)
			
			#Total
			box_container = scene.instantiate()
			box_container.get_node("Label").text=str(game_score[0][character])
			grid.add_child(box_container)
			
			#Survival
			box_container = scene.instantiate()
			box_container.get_node("Label").text=str(game_score[6][character])
			grid.add_child(box_container)
			
			#Friend
			box_container = scene.instantiate()
			box_container.get_node("Label").text=game_score[2][character+" Friend"]+": "+str(game_score[3][character+" Friend"])
			grid.add_child(box_container)
			
			#Enemy&Psychopath
			if str(game_score[3][character+" Enemy"])=="Psychopath":
				box_container = scene.instantiate()
				box_container.get_node("Label").text="Psychopath"+": "+str(game_score[3][character+" Psychopath"])
				grid.add_child(box_container)
			else:
				box_container = scene.instantiate()
				box_container.get_node("Label").text=game_score[2][character+" Enemy"]+": "+str(game_score[3][character+" Enemy"])
				grid.add_child(box_container)
			
			#Items
			
			var items = game_score[4][character].split(",",false)
			var vbox = VBoxContainer.new()
			if items.is_empty():
				box_container = scene.instantiate()
				box_container.get_node("Label").text="0"
				vbox.add_child(box_container)
			for item in items:
				var item_temp=item.split("_",false)
				item=""
				for item_t in item_temp:
					item+=item_t.to_pascal_case()+" "
				box_container = scene.instantiate()
				box_container.get_node("Label").text=item
				vbox.add_child(box_container)
			grid.add_child(vbox)
