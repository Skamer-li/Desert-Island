extends Node2D  

#@export var character_data: CharacterData
@onready var game = get_tree().get_first_node_in_group("game")

var food_coins: Array = []  # amount of food coins in array, 0 - 1p and 1 - 4p
var food_points: int = food_coins[0] # how many points of food you have
var health_points: int = 1  # HP based on character card (depends on char card)
var fate_coins: int = 1  # amount of fate coins (skulls)
var ally_card: String = "None"  # random ally character
var enemy_card: String = "None" # random enemy card
var items: Dictionary = {
	
} 
var food_points_loop: int = 2  # amount of food consumption each loop
var hp_loss: int = 1  # hunger penalty

# Function to initialize player stats
func _ready():

	emit_signal("stats_updated")

@onready var day_counter_label = $DayCounterLabel
@onready var foodquantity1_label = $FoodLabel
func _loop():
	$HPValueLabel.text = health_points
	$FateCoinLabel.text = fate_coins
	update_food()
	update_day(1)
	
#func use_special_ability():
#	match character_data.character_name:
#		"Explorer":
#			_explorer_ability()
#		"Doctor":
#			_doctor_ability()
#		"Cook":
#			_cook_ability()
#		"Captain":
#			_captain_ability()
#		"Hunter":
#			_hunter_ability()
#		"Engineer":
#			_engineer_ability()
	
func update_day(day):
	day_counter_label.text = "Day: " + str(day)
	
func update_food():
	foodquantity1_label.text = food_points - food_points_loop
	#embrion of food consumtion update
	
