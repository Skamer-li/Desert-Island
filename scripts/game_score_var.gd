extends Node
var game_score=[

	{"Cherpack":0,"First Mate":0,"Snob":0,"The Captain":0},
	{"The Captain Player":"","First Mate Player":"","Snob Player":"","Cherpack Player":""},
	{"Friend&Enemy":""},
	{"Friend&Enemy_Points":0},
	{"Items":""},
	{"Items_Points":0},
	{"Survival_Points":0}
	]

func game_score_init():
	var players = get_node("/root/game/players")
	for player in players.get_children():
		game_score[0][str(player.name)]=0
		game_score[2][str(player.name)+" Friend"]=player.friend_name
		game_score[2][str(player.name)+" Enemy"]=player.enemy_name
		game_score[3][str(player.name)+" Friend"]=0
		game_score[3][str(player.name)+" Enemy"]=0
		var item_list=""
		for item in player.get_node("Hand").get_children():
			if item.name!="DebugShape"&&item.value!=0:item_list+=", "+item.card_name+": "+ str(item.value)
		game_score[4][str(player.name)]=item_list
		game_score[5][str(player.name)]=0
		game_score[6][str(player.name)]=0
			
func give_points(character: String, points: int, player,point_type:String):
	game_score[0][character]+=points
	game_score[1][character+" Player"]=player
	match point_type:
		"Friend":
			game_score[3][character+" Friend"]+=points
		"Enemy":
			game_score[3][character+" Enemy"]+=points
		"Items":
			game_score[5][character]+=points
		"Survival":
			game_score[6][character]+=points
		"Baller":
			game_score[3][character+" Enemy"]="Psychopath"
			if points == -2:game_score[3][character+" Psychopath"]+=points
			else:game_score[3][character+" Psychopath"]=points
