extends Node2D

signal fate_card_resolved

@rpc("any_peer","call_local")
func fate_card_resolve():
	fate_card_resolved.emit()
