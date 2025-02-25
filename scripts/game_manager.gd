extends Node

const MAX_PLAYERS = 6

var players_id: Array[int] = []
var players_name: Array[String] = []

var roles = ["Cherpack", "First Mate", "Snob", "The Captain", "Milady", "The Kid"]
var locations = ["Beach", "Jungle", "Swamp", "Spring", "Hill", "Cave"]
var friends = ["Cherpack", "First Mate", "Snob", "The Captain", "Milady", "The Kid"]
var enemies = ["Cherpack", "First Mate", "Snob", "The Captain", "Milady", "The Kid"]
var items = ["bananas", "coconut", "crabs", "roasted_iguana", "sprats", "candelabrum", 
			 "chamber_pot", "cup", "doubloons", "medicine", "boarding_saber", "blunderbass",
			 "fishing_rod", "garden", "shovel", "spear", "tent", "trap", "monocle", "spotting_scope"]
