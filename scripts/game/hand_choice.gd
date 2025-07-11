extends Control

var sender_node_path
var reciever_node_path

var left
var right

func initialize(sender_path, reciever_path, left_amount, right_amount, is_steal_action):
	sender_node_path = sender_path
	reciever_node_path = reciever_path
	
	left = left_amount
	right = right_amount
	
	if (is_steal_action):
		#$left.pressed.connect(steal_left_action.bind())
		#$right.pressed.connect(steal_right_action.bind())
		$elements/left.pressed.connect(steal_left_action.bind())
		$elements/right.pressed.connect(steal_right_action.bind())

func steal_left_action():
	if (get_node(reciever_node_path).food_amount >= left):
		GameManager.decrease_food_amount.rpc_id(1, reciever_node_path, left)
		GameManager.increase_food_amount.rpc_id(1, sender_node_path, left)
		self.get_parent().get_parent().get_node("actions").get_node("basic_actions").disable_buttons.rpc_id(get_node(sender_node_path).player_id, true)
		self.queue_free()

func steal_right_action():
	if (get_node(reciever_node_path).food_amount >= right):
		GameManager.decrease_food_amount.rpc_id(1, reciever_node_path, right)
		GameManager.increase_food_amount.rpc_id(1, sender_node_path, right)
		self.get_parent().get_parent().get_node("actions").get_node("basic_actions").disable_buttons.rpc_id(get_node(sender_node_path).player_id, true)
		self.queue_free()
