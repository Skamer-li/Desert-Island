extends Control

@export var current_name = ""
@export var power = 0

func set_properties(name, power):
	self.name = name
	current_name = name
	self.power = power
	
	$name.text = name
	$power.text = str(power)
	
