extends Node2D

@onready var sprite_stack : SpriteStack2D = $SpriteStack2D

@onready var left_tire_anchor : Marker2D = $Anchors/LeftTireAnchor
@onready var right_tire_anchor : Marker2D = $Anchors/RightTrailAnchor

@onready var left_drift_particles : CPUParticles2D = $VFX/LeftDriftParticles
@onready var right_drift_particles : CPUParticles2D = $VFX/RightDriftParticles

@onready var tire_trail_manager : TireTrailManager = get_tree().get_first_node_in_group("TireTrailManager")

var left_trail : TireTrail
var right_trail : TireTrail

func update_stack_rotation(car_angle: float):
	sprite_stack.rotation_angle = car_angle - PI/2

func update_tire_trail(is_drifting, is_slipping):
	if is_drifting or is_slipping:
		left_drift_particles.emitting = true
		right_drift_particles.emitting =  true
		if not left_trail:
			left_trail = tire_trail_manager.create_trail()
			
		if not right_trail:
			right_trail = tire_trail_manager.create_trail()
	
		left_trail.update(left_tire_anchor.global_position)
		right_trail.update(right_tire_anchor.global_position)
	else:
		left_drift_particles.emitting = false
		right_drift_particles.emitting = false
		left_trail = null
		right_trail = null
