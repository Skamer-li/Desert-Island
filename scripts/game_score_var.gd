extends Node
var captain_score = 0
var cherpack_score = 0
var first_mate_score = 0
var the_kid_score = 0
var milady_score = 0
var snob_score = 0

func give_points(character: String, points: int):
	match character:
				"Cherpack":
					cherpack_score+=points
				"First Mate":
					first_mate_score+=points
				"Snob":
					snob_score+=points
				"The Captain":
					captain_score+=points
				"Milady":
					milady_score+=points
				"The Kid":
					the_kid_score+=points
