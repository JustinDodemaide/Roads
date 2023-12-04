extends Node2D

var object_scene:PackedScene
var blocked:bool = true

func init(level_object:PackedScene) -> void:
	object_scene = level_object
	var temp = level_object.instantiate()
	$Area2D/CollisionShape2D.shape = temp.get_node("StaticBody2D").get_node("CollisionShape2D").shape
	$AnimatedSprite2D.sprite_frames = temp.get_node("AnimatedSprite2D").sprite_frames
	temp.queue_free()
	
	Global.level.add_child(self)

var pulse:bool = false
func _process(_delta):
	if blocked:
		$AnimatedSprite2D.modulate = Color(1,0,0,0.5) # Red
	else:
		$AnimatedSprite2D.modulate = Color(0,1,0,0.5) # Green
	position = Global.world.tilemap.get_global_mouse_position()
	check_position()

func check_position():
	for area in $Area2D.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is LevelObject:
			blocked = true
		else:
			blocked = false

func _input(event):
	if event.is_action_pressed("LeftClick"):
		if blocked:
			return
		var blueprint = load("res://World/WorldObjects/LO_Blueprint.tscn").instantiate()
		blueprint.init(object_scene)
		blueprint.position = position
		Global.level.add_child(blueprint)
		queue_free()
