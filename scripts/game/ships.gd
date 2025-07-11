extends Node2D
@rpc("any_peer","call_local")
func create_ship(ships):
	var ship_scene = preload("res://scenes/ship_token.tscn")
	for ship in self.get_children():
		ship.queue_free()
	for i in range(ships):
		var token = ship_scene.instantiate()
		add_child(token)
		get_node("ship_token").scale=Vector2(0.5,0.5)
		get_node("ship_token").name="ship_token_"+str(i)
	var placment_vector=Vector2(25+10,0)
	if ships!=1 && ships!=0:
		var count =0
		for token in get_children():
			var base_angle=(2*PI)/ships
			token.position=placment_vector.rotated(base_angle*count)
			count+=1
	elif ships==1:
		for token in get_children():
			token.position=Vector2(0,0)
			token.z_index=1
