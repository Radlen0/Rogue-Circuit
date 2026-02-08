extends Line2D
class_name TireTrail

@export var resolution: float = 5.0
@export var max_age : float = 30.0

var time : float = 0

var points_age : Array[float]

func _init() -> void:
	default_color = Color.hex(0x212121df)
	width = 1.0
	z_index = -10

func update(point_position: Vector2) -> void:
	if points.size() == 0 or point_position.distance_to(points[-1]) > resolution :
		add_point(point_position)
		points_age.append(time)

func _process(delta: float) -> void:
	time += delta
	if points_age[0] <= time - max_age:
		points_age.pop_front()
		remove_point(0)
	if points.size() == 0:
		queue_free()
