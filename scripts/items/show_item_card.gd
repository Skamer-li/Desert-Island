extends Node2D

func change_texture(card_name: String):
	match(card_name):
		"bananas":
			$card.texture = load("res://sprites/items/bananas.png")
		"blunderbass":
			$card.texture = load("res://sprites/items/blunderbuss.png")
		"boarding_saber":
			$card.texture = load("res://sprites/items/boarding_saber.png")
		"candelabrum":
			$card.texture = load("res://sprites/items/candelabrum.png")
		"chamber_pot":
			$card.texture = load("res://sprites/items/chamber_pot.png")
		"coconut":
			$card.texture = load("res://sprites/items/coconut.png")
		"crabs":
			$card.texture = load("res://sprites/items/crabs.png")
		"cup":
			$card.texture = load("res://sprites/items/cup.png")
		"doubloons":
			$card.texture = load("res://sprites/items/doubloons.png")
		"fishing_rod":
			$card.texture = load("res://sprites/items/fishing_rod.png")
		"garden":
			$card.texture = load("res://sprites/items/garden.png")
		"medicine":
			$card.texture = load("res://sprites/items/medicine.png")
		"monocle":
			$card.texture = load("res://sprites/items/monocle.png")
		"roasted_iguana":
			$card.texture = load("res://sprites/items/roasted_iguana.png")
		"shovel":
			$card.texture = load("res://sprites/items/shovel.png")
		"spear":
			$card.texture = load("res://sprites/items/spear.png")
		"spotting_scope":
			$card.texture = load("res://sprites/items/spotting_scope.png")
		"sprats":
			$card.texture = load("res://sprites/items/sprats.png")
		"tent":
			$card.texture = load("res://sprites/items/tent.png")
		"trap":
			$card.texture = load("res://sprites/items/trap.png")
		"closed":
			$card.texture = load("res://sprites/items/items.png")
		_:
			pass
