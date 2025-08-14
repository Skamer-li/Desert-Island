extends Control

var food
@export var sender=""

signal division_finished(left, right)

func initialize(max_food, character):
	food = max_food
	sender = character
	$Sprite2D/left/box1.max_value = max_food
	$Sprite2D/right/box2.max_value = max_food

func _on_box_1_value_changed(value: float) -> void:
	$Sprite2D/right/box2.max_value = food - value
	

func _on_box_2_value_changed(value: float) -> void:
	$Sprite2D/left/box1.max_value = food - value

func _on_button_pressed() -> void:
	var left = $Sprite2D/left/box1.value
	var right = $Sprite2D/right/box2.value
	
	if (left + right == food):
		emit_signal("division_finished", left, right)
		self.queue_free()
