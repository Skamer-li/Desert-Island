extends Node2D  

# character stats variables
var food_required: int = 0  # how many points of food your character eats each loop (depends on char_card)
var food_coins: Array = [4, 0]  # amount of food coins in array, 0 - 1p and 1 - 4p
var food_points: int = food_coins[0] # how many points of food you have
var health_points: int = 1  # HP based on character card (depends on char card)
var fate_coins: int = 1  # amount of fate coins (skulls)
var character_card: String = "None"  # name and class of character (depends on this str we set all optional and basic stats and innate abilities)
var ally_card: String = "None"  # random ally character
var enemy_card: String = "None" # random enemy card
var items: Array = []  # first idea of inventory (items)

# Constants
var food_points_loop: int = 2  # amount of food consumption each loop
var hp_loss: int = 1  # hunger penalty

# Function to initialize player stats
func _ready():
	food_required = 1
	food_points = 10
	food_coins = [4, 0]
	health_points = 1
	fate_coins = 1
	character_card = "Hero_name"
	ally_card = "Hero_name"
	items = []

	emit_signal("stats_updated")
