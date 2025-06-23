extends Sprite2D

@onready var buttons = $players_to_choose.get_children()

func initialize() -> void:
	var player_node = self.get_parent().get_parent()
	var characters_node = player_node.get_parent()
	
	var i = 0 
	
	#showing all buttons
	for button in buttons:
		button.show()
	
	#setting names in correct order	
	for location in GameManager.const_locations:
		for player in characters_node.get_children():
			if (!player.is_dead && player.current_location == location && player != player_node):
				buttons[i].text = player.name
				i += 1
				break
	
	#hiding unused buttons
	for k in range(i, buttons.size()):
		buttons[k].hide()
	
	#connecting all buttons to the script
	for button in buttons:
		button.pressed.connect(choose_player.bind(button.text))

func _on_trade_button_pressed() -> void:
	self.show()
	initialize()
	
func choose_player(name):
	$"../send_trade".initialize(name)
	for button in buttons:
		button.pressed.disconnect(choose_player)
	self.hide()

func _on_close_button_pressed() -> void:
	self.hide()
