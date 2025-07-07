extends Node2D


func _on_music_finished() -> void:
	$music.play()

	
@rpc("any_peer","call_local")
func ship_horn():
	$effects.stream=load("res://sounds/ship_horn.ogg")
	$effects.play()
@rpc("any_peer","call_local")
func boar_attack():
	$effects.stream=load("res://sounds/the-boar.ogg")
	$effects.play()
@rpc("any_peer","call_local")
func monkey_attack():
	$effects.stream=load("res://sounds/monkey.ogg")
	$effects.play()
@rpc("any_peer","call_local")
func mosquito_attack():
	$effects.stream=load("res://sounds/mosquito.ogg")
	$effects.play()
@rpc("any_peer","call_local")
func rat_attack():
	$effects.stream=load("res://sounds/rats.ogg")
	$effects.play()
@rpc("any_peer","call_local")	
func tsunami():
	$effects.stream=load("res://sounds/tsunami.ogg")
	$effects.play()
func _on_music_ready() -> void:
	if $music.playing==false: $music.play()
