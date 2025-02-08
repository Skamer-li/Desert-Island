@tool
class_name Hand extends Node2D

@export var hand_radius: int = 100
@export var card_angle: float = -90
@export var angle_limit: float = 25
@export var max_card_spread_angle: float = 5

@onready var test_card = $StaticBody2D/TextureRect
@onready var collision_shape: CollisionShape2D = $DebugShape

var hand : Array = []

func add_card(card, Node2D):
	hand.push_back(card)
	add_child(card)
	reposition_cards()

func reposition_cards():
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var curr_angle = -(card_spread * (hand.size() - 1)/2 - 90)
	for card in hand:
		update_card_transform(card, curr_angle)
		curr_angle += card_spread

func get_card_position(angle_in_deg: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(angle_in_deg))
	var y: float = hand_radius * sin(deg_to_rad(angle_in_deg))
	
	return Vector2(int(x), int(y))
	pass

func update_card_transform(card: Node2D, angle_in_drag: float):
	card.set_position(get_card_position(angle_in_drag))
	card.set_rotation(deg_to_rad(angle_in_drag + 90))

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)
		
	test_card.set_position(get_card_position(card_angle))
	test_card.set_rotation(deg_to_rad(card_angle + 90)) #center cards later
	
