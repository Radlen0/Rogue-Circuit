extends Camera2D

@export var default_offset : float = 15
@export var max_offset : float = 40

@onready var car : CharacterBody2D = $".."

func _process(_delta: float) -> void:
	var forward_velocity : float = -car.transform.y.dot(car.velocity)
	var forward_velocity_ratio : float = forward_velocity / car.max_speed
	position = Vector2.UP * ((max_offset - default_offset) * forward_velocity_ratio + default_offset)
