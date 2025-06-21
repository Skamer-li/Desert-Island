
class_name Hand extends Node2D

@export var hand_radius: int = 1000
@export var card_angle: float = -80
@export var angle_limit: float = 20
@export var max_card_spread_angle: float = 5

@onready var collision_shape: CollisionShape2D = $DebugShape

var cards : Array = []

func _ready() -> void:
	pass
		
func add_card(card):
	if card:
		cards.push_back(card)
		add_child(card)
		reposition_cards()

func reposition_cards():
	var card_spread = min(angle_limit / cards.size(), max_card_spread_angle)
	var curr_angle = card_angle -(card_spread * (cards.size() - 1))/2 
	for card in cards:
		update_card_transform(card, curr_angle)
		curr_angle += card_spread

func get_card_position(angle_in_deg: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(angle_in_deg))
	var y: float = hand_radius * sin(deg_to_rad(angle_in_deg))
	return Vector2(int(x), int(y))
	
func update_card_transform(card: Node2D, angle_in_deg: float):
	card.set_position(get_card_position(angle_in_deg))
	card.set_rotation(deg_to_rad(angle_in_deg + 90))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)
