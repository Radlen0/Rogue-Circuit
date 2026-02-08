extends CharacterBody2D

# --- Configuration ---
@export_group("Engine Settings")
@export var torque_curve: Curve  
@export var max_reverse_speed: float = 100.0
@export var max_speed: float = 250.0
@export var friction: float = 40.0
@export var braking_strength: float = 200.0

@export_group("Steering Mechanics")
@export var wheel_base: float = 50.0  
@export var steer_angle: float = 25.0
@export var steering_response: float = 20.0 
@export var drifting_speed: float = 80.0

@export_group("Physics") 
@export var tire_grip_curve: Curve

# --- State Variables ---
var current_steer_angle: float = 0.0

var is_drifting: bool = false :
	get:
		var side_direction : Vector2 = transform.x
		var lateral_velocity : float = side_direction.dot(velocity)
		return abs(lateral_velocity) >= drifting_speed
var is_tires_slipping : bool = false :
	get:
		var speed = velocity.length()
		var throttle = Input.get_action_strength("accelerate")
	
		# If we are pushing gas hard but moving slowly, tires are spinning!
		if throttle > 0.8 and speed < 100:
		# Return a value between 0 and 1 based on how much spin there is
			return remap(speed, 0, 250, 0.0, 1.0) < 0.5
		return false
	
# --- References ---
@onready var input_component: Node = $Components/InputComponent
@onready var car_visual: Node2D = $CarVisual

func _physics_process(delta: float) -> void:
	var throttle_input : float = input_component.throttle
	var steering_input : float = input_component.steering
	var brake_input : float = input_component.brake
	
	apply_acceleration(throttle_input, brake_input, delta)
	apply_steering(steering_input, delta)
	apply_traction(delta)
	move_and_slide()
	update_visual()


func apply_acceleration(throttle : float, brake : float, delta : float) -> void:
	var forward_direction : Vector2 = -transform.y
	
	if throttle:
		var forward_velocity : float = forward_direction.dot(velocity)
		if throttle > 0:
			var forward_speed_ratio : float = abs(forward_velocity) / max_speed
			var engine_power = torque_curve.sample(forward_speed_ratio) * 200
			velocity = velocity.move_toward(forward_direction * max_speed * throttle, engine_power * delta)
		else:
			var forward_speed_ratio : float = abs(forward_velocity) / max_reverse_speed
			var engine_power = torque_curve.sample(forward_speed_ratio) * 150
			velocity = velocity.move_toward(forward_direction * max_reverse_speed * throttle, engine_power * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if brake:
		velocity = velocity.move_toward(Vector2.ZERO, braking_strength * delta)
	
func apply_steering(steering: float, delta: float) -> void:
	# Prevent turning while stationary
	if velocity.length() < 10:
		return
	
	# 1. Calculate steering angle
	var target_angle : float = steering * deg_to_rad(steer_angle)
	current_steer_angle = move_toward(current_steer_angle, target_angle, steering_response * delta)
	
	# 2. Calculate Axle Positions
	var rear_wheels : Vector2 = position + transform.y * (wheel_base / 2)
	var front_wheels : Vector2 = position - transform.y * (wheel_base / 2)
	
	# 3. Move Axles
	rear_wheels += velocity * delta
	front_wheels += velocity.rotated(current_steer_angle) * delta
	
	# 4. Update Heading and Velocity
	var new_heading : Vector2 = rear_wheels.direction_to(front_wheels)
	
	rotation = new_heading.angle() + PI/2

func apply_traction(delta) -> void:
	# Elimenate the lateral velocity gradually
	var side_direction : Vector2 = transform.x
	var lateral_velocity : float = side_direction.dot(velocity)
	
	var target_velocity : Vector2 = velocity - side_direction * lateral_velocity
	
	var lateral_speed_ratio : float = abs(lateral_velocity) / max_speed
	var tire_grip : float = tire_grip_curve.sample(lateral_speed_ratio) * 300
	velocity = velocity.move_toward(target_velocity, tire_grip * delta)

func update_visual() -> void:
	car_visual.update_stack_rotation(rotation)
	car_visual.update_tire_trail(is_drifting, is_tires_slipping)
