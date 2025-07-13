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
			 "chamber_pot", "cup", "doubloons", "medicine", "boarding_saber", "blunderbuss",
			 "fishing_rod", "garden", "shovel", "spear", "tent", "trap", "monocle", "spotting_scope"]
var items_database = [
	{"name": "bananas", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 4, "damage": 0, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": false},
	{"name": "blunderbuss", "food_amplification": 0, "hunger_food_decrease": 0, "food_gain": 0, "damage": 10, "value": 0, "heal": 0, "build_amplification": 0, "can_be_activated": true},
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
var fate_deck = [
	"res://sprites/fate cards/b_cap_5_boards.png","res://sprites/fate cards/b_c_6_torch.png","res://sprites/fate cards/b_fm_4_ship.png","res://sprites/fate cards/b_k_3_torch.png","res://sprites/fate cards/b_m_2_boards.png","res://sprites/fate cards/b_s_1_ship.png",
	"res://sprites/fate cards/mk_cap_1_boards.png","res://sprites/fate cards/mk_c_2_torch.png","res://sprites/fate cards/mk_fm_6_ship.png","res://sprites/fate cards/mk_k_5_torch.png","res://sprites/fate cards/mk_m_4_boards.png","res://sprites/fate cards/mk_s_3_ship.png",
	"res://sprites/fate cards/m_cap_6_boards.png","res://sprites/fate cards/m_c_1_torch.png","res://sprites/fate cards/m_fm_5_ship.png","res://sprites/fate cards/m_k_4_torch.png","res://sprites/fate cards/m_m_3_boards.png","res://sprites/fate cards/m_s_2_ship.png",
	"res://sprites/fate cards/r_cap_4_boards.png","res://sprites/fate cards/r_c_5_torch.png","res://sprites/fate cards/r_fm_3_ship.png","res://sprites/fate cards/r_k_2_torch.png","res://sprites/fate cards/r_m_1_boards.png","res://sprites/fate cards/r_s_6_ship.png",
	"res://sprites/fate cards/t_cap_3_boards.png","res://sprites/fate cards/t_c_4_torch.png","res://sprites/fate cards/t_fm_2_ship.png","res://sprites/fate cards/t_k_1_torch.png","res://sprites/fate cards/t_m_6_boards.png","res://sprites/fate cards/t_s_5_ship.png"
]
var fate_deck_discard = []

var logged_in=0

@rpc ("any_peer","call_local")
func deal_damage(character_path, dmg=1):
	var character = get_node(character_path)
	var character_name= character.character_name
	var chars = character.get_parent().get_parent().get_node("characters")
	character.wound_amount += dmg
	if character.is_dead:
		chars.get_node(character_name).texture_load.rpc(character_name)
		character.self_texture_load.rpc_id(character.player_id, character_name)
		character.get_parent().get_parent().get_node("locations").get_node(character.current_location).set_closed_sprite.rpc()

@rpc ("any_peer","call_local")
func fate_update():
	var players = get_node("/root/game/players")
	var locations = get_node("/root/game/locations")
	for character in players.get_children():
		character.update_fate_tokens()
		character.location_fate=locations.get_node(character.current_location).fate_token_amount
		locations.get_node(character.current_location).fate_token_placing.rpc(character.location_fate,60,2)
		character.fate_amount=0
