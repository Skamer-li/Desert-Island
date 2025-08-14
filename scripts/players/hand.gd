
class_name Hand extends Node2D

@export var hand_radius: int = 1000
@export var card_angle: float = -80
@export var angle_limit: float = 20
@export var max_card_spread_angle: float = 5

@export var popup_offset: float = -100
@export var popup_spacing: float = 20
@export var anim_time: float = 1

@onready var collision_shape: CollisionShape2D = $DebugShape

@export var cards : Array = []

var highlight_index: int = -1
var selected_index: int = -1
var touched_cards: Array = []

func _ready() -> void:
	pass
		
func add_card(card):
	if card:
		cards.push_back(card)
		add_child(card)
		reposition_cards()
		
func card_connect(card):
	card.mouse_entered.connect(_handle_card_touched)
	card.mouse_exited.connect(_handle_card_untouched)

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
	
func delete_card_from_array(card_name):
	if (cards.size() == 2):
		print("d")
	var item 
	for card in cards:
		if (card.name == card_name):
			item = card
			break
	
	cards.erase(item)

func _handle_card_touched(card):
	touched_cards.push_back(card)

func _handle_card_untouched(card):
	touched_cards.remove_at(touched_cards.find(card))

func popup_card(index: int):
	if index < 0 or index >= cards.size():
		return
	selected_index = index
	reposition_cards()

	for i in range(cards.size()):
		var card = cards[i]
		var target_pos = card.position
		if i == selected_index:
			target_pos.y += popup_offset
			card.z_index = 100
		else:
			card.z_index = 0
			if i < selected_index:
				target_pos.x -= popup_spacing
			elif i > selected_index:
				target_pos.x += popup_spacing
		_animate_card(card, target_pos)

func reset_popup():
	selected_index = -1
	for card in cards:
		card.z_index = 0
	reposition_cards()	

func _animate_card(card: Node2D, target_pos: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", target_pos, anim_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	reset_popup()
	
	if !touched_cards.is_empty():
		var highest_touched_index = -1
		for touched_card in touched_cards:
			highest_touched_index = max(highest_touched_index, cards.find(touched_card))
		if highest_touched_index >= 0 && highest_touched_index < cards.size():
			popup_card(cards.find(cards[highest_touched_index]))
	
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)
