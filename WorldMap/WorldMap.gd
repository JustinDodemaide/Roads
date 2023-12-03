extends Node

var state_machine

var selected_object:WorldMapObject

func enter(_msg:Dictionary = {})->void:
	for object in Global.world.world_objects:
		new_map_object(object)
	Global.world.tilemap.visible = true
	Global.world.new_object.connect(new_map_object)

func exit()->void:
	Global.world.tilemap.visible = false

func _process(delta):
	$Cursor.position = Global.world.tilemap.get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("LeftClick"):
		var areas = $Cursor.get_overlapping_areas()
		if not areas.is_empty():
			selected_object = areas.front().get_parent()
			selected_object.select()
		else:
			if selected_object != null:
				selected_object.deselect()
				selected_object = null

func new_map_object(object:WorldObject) -> void:
	var packed_map_object:PackedScene = preload("res://WorldMap/WorldMapObject/WorldMapObject.tscn")
	var new_wmo = packed_map_object.instantiate()
	new_wmo.init(object)
	add_child(new_wmo)
