extends Node
var game_score=[
	{"Cherpack":0,"First Mate":0,"Snob":0,"The Captain":0, "The Kid":0, "Milady":0},
	{"The Captain Player":"","First Mate Player":"","Snob Player":"","Cherpack Player":""}
	]

func give_points(character: String, points: int, player):
	game_score[0][character]+=points
	game_score[1][character+" Player"]=player
	
