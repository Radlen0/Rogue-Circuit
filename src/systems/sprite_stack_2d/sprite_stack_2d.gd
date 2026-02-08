@tool
extends Node2D
class_name SpriteStack2D

@export var texture_resource : SpriteFrames
@export var offset : int = 1


@export_tool_button("Create Stack") var create_stack = func () :
	for child in get_children():
		child.queue_free()
	
	if not texture_resource:
		printerr("No SpriteFrames assigned!")
		return
		
	for i in range(texture_resource.get_frame_count("default")):
		var frame_texture = texture_resource.get_frame_texture("default", i)
			
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = frame_texture
		sprite.position.y = -i * offset
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		sprite.name = "Layer_" + str(i)

@export_range(0, 360) var rotation_deg : float = 0:
		set(value):
			rotation_deg = value
			rotation_angle = deg_to_rad(value)
			update_rotation(deg_to_rad(rotation_angle))
		get:
			return rad_to_deg(rotation_angle)
var rotation_angle : float = 0

@export var face_camera : bool = true 

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if face_camera:
		var cam = get_viewport().get_camera_2d()
		global_rotation = cam.get_screen_rotation()
		update_rotation(rotation_angle - global_rotation)

func update_rotation(rotation_value: float) -> void:
	for sprite in get_children():
		sprite.rotation = rotation_value
