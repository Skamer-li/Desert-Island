extends Node2D  
var player = $Player
var captain = CaptainStats.new()
player.set_character(captain)
# character stats variables
var food_coins: Array = []  # amount of food coins in array, 0 - 1p and 1 - 4p
var food_points: int = food_coins[0] # how many points of food you have
var health_points: int = 1  # HP based on character card (depends on char card)
var fate_coins: int = 1  # amount of fate coins (skulls)
var ally_card: String = "None"  # random ally character
var enemy_card: String = "None" # random enemy card
var items: Array = []  # first idea of inventory (items)

# Constants
var food_points_loop: int = 2  # amount of food consumption each loop
var hp_loss: int = 1  # hunger penalty

# Function to initialize player stats
func _ready():
	player.modify_food_coins(4, 0)
	player.modify_food_points(food_coins[0] * 1 + food_coins[1] * 4)
	player.modify_ally_card("Hero_name")
	player.modify_enemy_card("Hero_name")
	items = []

	emit_signal("stats_updated")
