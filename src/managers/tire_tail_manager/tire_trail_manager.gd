extends Node2D
class_name TireTrailManager

func create_trail() -> TireTrail:
	var tire_trail : TireTrail = TireTrail.new()
	add_sibling(tire_trail)
	return tire_trail
