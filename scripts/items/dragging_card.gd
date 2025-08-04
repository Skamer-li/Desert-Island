extends Node2D

const SPEED = 50.0
const CARD_COLLISION_MASK = 1

var card_dragged

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.pressed):
			var card = raycast_check()
			
			if (card):
				card_dragged = card
		else:
			card_dragged = null

func raycast_check():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_COLLISION_MASK
	
	var result = space_state.intersect_point(parameters)
	
	if (result.size() > 0):
		return result[0].collider.get_parent()
	return null
	
func _process(delta: float) -> void:
	if (card_dragged):
		var mouse_pos = get_global_mouse_position()
		
		card_dragged.position = card_dragged.position.lerp(Vector2(clamp(mouse_pos.x, 0, get_window().size.x), clamp(mouse_pos.y, 0, get_window().size.y)), delta * SPEED)
