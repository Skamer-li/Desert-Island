extends Node2D


func _on_music_finished() -> void:
	$music.play()

	
@rpc("any_peer","call_local")
func ship_horn():
	$effects.stream=load("res://sounds/ship_horn.ogg")
	$effects.play()
