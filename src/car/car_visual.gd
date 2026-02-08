extends Node2D

@onready var sprite_stack : SpriteStack2D = $SpriteStack2D

func update_stack_rotation(car_angle: float):
	sprite_stack.rotation_angle = rad_to_deg(car_angle - PI/2)
