extends Node

var throttle : float :
	get:
		return Input.get_axis("reverse", "accelerate")

var brake : bool:
	get:
		return Input.is_action_pressed("brake")

var steering : float :
	get:
		return Input.get_axis("steer_left", "steer_right")
