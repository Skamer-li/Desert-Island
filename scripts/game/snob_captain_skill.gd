extends Control

@onready var buttons = $Sprite2D/HBoxContainer.get_children()

func initialize(character):
	var hidden_amount = 0
	var i = 0
	
	for location in GameManager.const_locations:
		for current_char in self.get_parent().get_parent().get_children():
			if (!current_char.is_dead && current_char.current_location == location):
				buttons[i].text = current_char.name
				
				if (character == "The Captain" && (buttons[i].text == "The Captain" || current_char.char_fate == 0)):
					hidden_amount += 1
					buttons[i].hide()
					
				i += 1
				break
				
	#hiding unused buttons
	for k in range(i, buttons.size()):
		hidden_amount += 1
		buttons[k].hide()
		
	if (hidden_amount == buttons.size()):
		self.get_parent().get_node("SkillButton").disabled = true
		self.queue_free()
		
	#connecting all buttons to the script
	for button in buttons:
		button.pressed.connect(use_skill.bind(button.text, character))

func use_skill(target_name, character):
	var target_node_path = self.get_parent().get_parent().get_node(target_name).get_path()
	
	if (character == "The Captain"):
		GameManager.decrement_fate.rpc_id(1, target_node_path)
	else:
		GameManager.increment_fate.rpc_id(1, target_node_path)
	
	self.get_parent().get_node("SkillButton").disabled = true
	self.queue_free()


func _on_close_button_pressed() -> void:
	self.queue_free()
