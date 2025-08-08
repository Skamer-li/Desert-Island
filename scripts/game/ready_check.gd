extends Control

var player_id
signal ready_active

func init_id(id):
	player_id=id
	
func _on_ready_button_pressed() -> void:
	$bg/Sam.region_rect=Rect2(0, 0, 0, 0)
	$bg/Sam.texture=load("res://sprites/characters/sam2.jpg")
	$bg/ready_button.disabled=true
	ready_active.emit()
