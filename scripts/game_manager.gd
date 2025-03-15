extends Node

const MAX_PLAYERS = 6

var players_id: Array[int] = []
var players_name: Array[String] = []

var roles = ["Cherpack", "First Mate", "Snob", "The Captain", "Milady", "The Kid"]
var locations = ["Beach", "Jungle", "Swamp", "Spring", "Hill", "Cave"]
var const_locations = ["Beach", "Jungle", "Swamp", "Spring", "Hill", "Cave"]
var friends = ["Cherpack", "First Mate", "Snob", "The Captain", "Milady", "The Kid"]
var enemies = ["Cherpack", "First Mate", "Snob", "The Captain", "Milady", "The Kid"]
var items = ["bananas", "coconut", "crabs", "roasted_iguana", "sprats", "candelabrum", 
			 "chamber_pot", "cup", "doubloons", "medicine", "boarding_saber", "blunderbass",
			 "fishing_rod", "garden", "shovel", "spear", "tent", "trap", "monocle", "spotting_scope"]
var items_database = [
	{"name": "bananas", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 4, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "blunderbass", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 10, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "boarding_saber", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 4, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "candelabrum", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 6, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "chamber_pot", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 5, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "coconut", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 1, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "crabs", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 3, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "cup", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 7, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "doubloons", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 3, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "fishing_rod", "food_amplification": 2, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "garden", "food_amplification": 2, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "medicine", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 0, "heal": 1, "build_amplification": 0, "can_be_activated": false},
	{"name": "monocle", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 1, "heal": 0, "build_amplification": 1, "can_be_activated": true},
	{"name": "roasted_iguana", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 2, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "shovel", "food_amplification": 2, "hunger_food_decrease": 0, "food_gain": 0, "damage": 2, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "spear", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 3, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "spotting_scope", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 2, "heal": 0, "build_amplification": 1, "can_be_activated": true},
	{"name": "sprats", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 5, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "tent", "food_amplification": 0, "hunger_food_decrease": 2, "food_gain": 0, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
	{"name": "trap", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false}
	
]
