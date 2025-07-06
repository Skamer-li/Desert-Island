extends Control
var scores=[]
func sort_descending(a, b):
	if a > b:
		return true
	return false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		logged_in_plus_plus()
		for characters in GameScoreVar.game_score[0]:
			scores.append(GameScoreVar.game_score[0][characters])
		scores.sort_custom(sort_descending)
	else:
		logged_in_plus_plus.rpc_id(1)
		
func _process(delta: float) -> void:
	if multiplayer.is_server()&&GameManager.logged_in==GameManager.players_id.size():
		display_score.rpc(scores,GameScoreVar.game_score)
		GameManager.logged_in=1000
		
@rpc("any_peer","call_local")
func display_score(scores,game_score):
	print("HHHH")
	var scene =preload("res://scenes/container_box.tscn")
	var winners=[]
	for characters in game_score[0]:
		if game_score[0][characters]==scores.max():
			winners.append(characters)
	$Panel/ReferenceRect2/Label.text=(", ".join(winners)+" Won")
	for score in scores:
		var nth_place_holders=[]
		var players=[]
		for characters in game_score[0]:
			if game_score[0][characters]==score:
				nth_place_holders.append(characters)
				players.append(str(game_score[1][characters+" Player"]))
		var box_container=scene.instantiate()
		var box_container2=scene.instantiate()
		$Panel/GridContainer.add_child(box_container)
		$Panel/GridContainer.get_node("container_box").get_node("Label").text="{}({})".format([", ".join(nth_place_holders)," ,".join(players)], "{}")
		$Panel/GridContainer.get_node("container_box").name=nth_place_holders[0]
		$Panel/GridContainer.add_child(box_container2)
		$Panel/GridContainer.get_node("container_box").get_node("Label").text=str(score)
		$Panel/GridContainer.get_node("container_box").name=nth_place_holders[0]+"1"

@rpc("any_peer")
func logged_in_plus_plus():
	GameManager.logged_in+=1
func _on_button_pressed() -> void:
	MenuClick.play()
	await MenuClick.finished
	get_tree().quit()
