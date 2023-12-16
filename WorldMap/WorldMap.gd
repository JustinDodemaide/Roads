extends Node

signal map_object_clicked(object:WorldMapObject)

func enter(_msg:Dictionary = {})->void:
	for object in Global.world.world_objects:
		new_map_object(object)
	Global.world.tilemap.visible = true
	Global.world.new_object.connect(new_map_object)
	Global.world.removed_object.connect(new_map_object)

func exit()->void:
	Global.world.tilemap.visible = false
	
func new_map_object(object:WorldObject) -> void:
	var packed_map_object:PackedScene = preload("res://WorldMap/WorldMapObject/WorldMapObject.tscn")
	var new_wmo = packed_map_object.instantiate()
	new_wmo.init(object)
	add_child(new_wmo)

func remove_world_object(object:WorldObject) -> void:
	for i in get_children():
		if i is WorldMapObject:
			if i.world_object == object:
				i.queue_free()
				return

func _process(delta):
	$Cursor.position = Global.world.tilemap.get_global_mouse_position()
	$UI/GeneralInfo/WorldPosition.text = "(" + str(round($Cursor.position.x)) + ", " + str(round($Cursor.position.y)) + ")"

func _input(event):
	if event.is_action_pressed("LeftClick"):
		var areas = $Cursor.get_overlapping_areas()
		if not areas.is_empty():
			emit_signal("map_object_clicked",areas.front().get_parent())
			return
	
	if event.is_action_pressed("M"):
		Global.scene_handler.transition_to("res://Level/Level.tscn",  {"WorldObject": Global.player_location})

func clear_ui() -> void:
	for child in $UI.get_children():
		if child.name == "GeneralInfo":
			continue
		child.queue_free()
