extends Node

var ui
signal map_object_clicked(object:WorldMapObject)

var packed_map_object:PackedScene = preload("res://WorldMap/WorldMapObject/WorldMapObject.tscn")

func enter(_msg:Dictionary = {})->void:
	for object in Global.world.world_objects:
		new_map_object(object)
	Global.world.tilemap.visible = true
	Global.world.new_object.connect(new_map_object)
	Global.world.removed_object.connect(new_map_object)
	$Camera2D.position = Vector2(4000,4000)
	ui = $UI
	if _msg.has("module"):
		# HACK Not ideal but I needed a way for the CharacterMover
		# to know if an attack was being planned or if characters were
		# being moved
		if _msg.has("module_msg"):
			load_module(_msg["module"],_msg["module_msg"])
		else:
			load_module(_msg["module"])
	else:
		load_module("MapViewer")

func exit()->void:
	Global.world.tilemap.visible = false
	$Module.queue_free()
	
func new_map_object(object:WorldObject) -> void:
	var new_wmo = packed_map_object.instantiate()
	new_wmo.init(object)
	new_wmo.clicked.connect(clicked)
	add_child(new_wmo)

func remove_world_object(object:WorldObject) -> void:
	for i in get_children():
		if i is WorldMapObject:
			if i.world_object == object:
				i.queue_free()
				return

func load_module(module_name:String,_msg = {}) -> void:
	var module = load("res://WorldMap/Modules/" + module_name + "/" + module_name + ".tscn").instantiate()
	module.name = "Module"
	module.world_map = self
	if not _msg.is_empty():
		module.msg = _msg
	add_child(module)

func _process(_delta):
	$Cursor.position = Global.world.tilemap.get_global_mouse_position()
	$UI/GeneralInfo/WorldPosition.text = "(" + str(round($Cursor.position.x)) + ", " + str(round($Cursor.position.y)) + ")"

func _input(event):
	if event.is_action_pressed("M"):
		if Global.current_location != null:
				Global.scene_handler.transition_to("res://Level/Level.tscn", {"WorldObject": Global.current_location})

func add_to_ui(element)->void:
	$UI.add_child(element)

func clear_ui() -> void:
	for child in $UI.get_children():
		if child.name == "GeneralInfo":
			continue
		child.queue_free()

func clicked(object:WorldMapObject):
	emit_signal("map_object_clicked",object)
