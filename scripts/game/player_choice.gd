extends Sprite2D

@onready var buttons = $players_to_choose.get_children()

@export var caller = "Character"

var is_trade = false

func initialize() -> void:
	var player_node = $"../../players".get_node(caller)
	var characters_node = $"../../players"
	
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
		button.pressed.connect(choose_player.bind(button.text, is_trade))

func start(trade_flag, caller_name) -> void:
	is_trade = trade_flag
	caller = caller_name
	self.show()
	initialize()
	
func choose_player(name, trade_flag):
	if (trade_flag):
		$"../../players".get_node(caller).get_node("trade").get_node("send_trade").initialize(name)
	else:
		$"../steal".show()
		$"../steal".initialize(caller, name)
		
	for button in buttons:
		button.pressed.disconnect(choose_player)
		
	self.hide()

func _on_close_button_pressed() -> void:
	self.hide()
	if (!is_trade):
		$"../basic_actions".disable_buttons(false)
