extends Node2D
var fate_card=0
signal fate_card_resolved

@rpc("any_peer","call_local")
func fate_card_resolve():
	fate_card_resolved.emit()
	fate_card+=1
