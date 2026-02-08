extends Node

var throttle : float :
	get:
		return Input.get_axis("reverse", "accelerate")

var steering : float :
	get:
		return Input.get_axis("steer_left", "steer_right")
