extends Control
var player_id=1
var char
var initialized = false
var text_edit
var collapse
var expand

func _ready() -> void:
	text_edit = $Panel/VBoxContainer/TextEdit
	collapse = $Panel/Collapse
	expand = $ExpandPanel/Expand
	
@rpc("any_peer","call_local")		
func init(id) -> void:
	player_id=id
	for player in get_parent().get_node("players").get_children():
		if player.player_id==player_id:
			char=get_node(get_path_to(player))
			initialized=true

func _on_line_edit_text_submitted(new_text: String) -> void:
	if initialized==false:
		for player in get_parent().get_node("players").get_children():
			init.rpc_id(player.player_id,player.player_id)
	
	if new_text.replace(" ","")=="":
		pass
	else: 
		GameManager.send_message.rpc(new_text,char.player_name,char.character_name)
		$Panel/VBoxContainer/LineEdit.clear()


func _on_collapse_pressed() -> void:
	collapse.hide()
	collapse.disabled=true
	text_edit.selecting_enabled=false
	text_edit.hide()
	expand.show()
	$ExpandPanel.show()
	expand.disabled=false
	$Panel.hide()
	
func _on_expand_pressed() -> void:
	$Panel.show()
	$ExpandPanel.hide()
	collapse.show()
	collapse.disabled=false
	text_edit.selecting_enabled=true
	text_edit.show()
	expand.hide()
	expand.disabled=true
