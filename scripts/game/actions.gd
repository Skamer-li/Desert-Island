extends Node2D

signal action_finished

func _on_h_c_pressed() -> void:
	if not multiplayer.is_server():
		deal_damage.rpc_id(1, "Cherpack")
		self.hide()
	else:
		deal_damage("Cherpack")
		self.hide()

func _on_h_m_pressed() -> void:
	if not multiplayer.is_server():
		deal_damage.rpc_id(1, "Milady")
		self.hide()
	else:
		deal_damage("Milady")
		self.hide()

@rpc ("any_peer")
func deal_damage(character: String):
	$"../../players".get_node(character).wound_amount += 1
	action_finished.emit()
