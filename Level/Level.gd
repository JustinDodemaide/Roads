extends Node

# Level

var world_object:WorldObject
var tileset_prefab:int

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["WorldObject"]
	Global.current_location = world_object
	#if world_object.level_id == 0:
	#	generate_level()
	#	save()
	#load_level()

func exit()->void:
	#save()
	Global.save_game()

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("M"):
		Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module": "MapViewer"})
	if event.is_action_pressed("1"):
		world_object.add_characters([Character.new()])

func save():
	# What needs to be saved:
	# 	All LevelObjects
	var file_path:String = "user://" + str(StartGameParameters.save) + "Level" + str(world_object.level_id) + ".save"
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	if save_file == null:
		return
	if not save_file.is_open():
		return
	# var tilemap_data = $TileMap.save()
	# tilemap_data = JSON.stringify(tilemap_data)
	# save_file.store_line(tilemap_data)
	
	save_file.close()

func load_level() -> void:
	var file_path:String = "user://" + str(StartGameParameters.save) + "Level" + str(world_object.level_id) + ".save"
	if not FileAccess.file_exists(file_path):
		print("file doesnt exist")
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var line = save_file.get_line()
		# Get the data from the JSON object
		var data:Dictionary = JSON.parse_string(line)
		var new_object = load(data["filepath"]).instantiate()
		new_object._load(data)
		if data["parent"] == "Level":
			add_child(new_object)
		else:
			get_node(data["parent"]).add_child(new_object)
	save_file.close()

func generate_level() -> void:
	world_object.level_id = get_instance_id()
	# Lab - Research menu
	# Foundry - Equipment menu
	# Garage - Relocated units
	# Armory - Customize units
	# Mission launcher
	# Resources
	# Needs to built: Harvesters

func _on_button_pressed():
	var file_path:String = "user://test.save"
	var save_file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	var json_string = JSON.stringify("line")
	save_file.seek_end()
	save_file.store_line(json_string)
