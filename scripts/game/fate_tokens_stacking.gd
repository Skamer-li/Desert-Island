extends Node2D


@rpc("any_peer","call_local")
#input amount of fate tokens, and radius of a circle
func fate_token_placing(fate_token_amount, circle_radius):
	var token_scene = preload("res://scenes/fate/fate_token.tscn")
	for fate_token in self.get_children():
		fate_token.queue_free()
	for i in range(fate_token_amount):
		var token = token_scene.instantiate()
		add_child(token)
		get_node("FateToken").name="fate_token_"+str(i)
	var placment_vector=Vector2(circle_radius+10,0)
	if fate_token_amount!=1 && fate_token_amount!=0:
		var count =0
		for token in get_children():
			var base_angle=(2*PI)/fate_token_amount
			token.position=placment_vector.rotated(base_angle*count)
			count+=1
	elif fate_token_amount==1:
		for token in get_children():
			token.position=Vector2(0,0)
			token.z_index=1
