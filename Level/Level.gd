extends Node

var state_machine

var world_object:WorldObject
# Interactables
# NPCs
# Placing objects
# Placing tiles
# Refactor for multiplayer:
#	Each player needs a UI, PlayerCharacter, cursor
#	Probably want to figure out how multiplayer works before you overthrow
#	this entire project for it? Moron
# Inventory

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["WorldObject"]
	if world_object.level_id == 0:
		world_object.generate_level()
	Global.level = self
	Global.player_location = world_object
	load_level(world_object.level_id)
	$PlayerCharacter.held_item = ItemStack.new(load("res://Items/Waffle/Item_Waffle.gd").new())
	# $PlayerCharacter.add_item(ItemStack.new(load("res://Items/Waffle/Item_Waffle.gd").new()))

func exit()->void:
	save()

func _process(_delta):
	$Cursor.position = Global.world.tilemap.get_global_mouse_position()

	var areas = $Cursor.get_overlapping_areas()
	if not areas.is_empty() and $PlayerCharacter.position.distance_to($Cursor.position) < 250:
		var parent = areas.front().get_parent()
		if parent is LevelObject:
			$Cursor/CursorLabel.text = parent._name()
	else:
		$Cursor/CursorLabel.text = ""

func _input(event):
	if event.is_action_pressed("LeftClick"):
		if $PlayerCharacter.position.distance_to($Cursor.position) > 250:
			return
		for i in $Cursor.get_overlapping_areas():
			var parent = i.get_parent()
			if parent is LevelObject:
				if parent.is_interaction_valid($PlayerCharacter):
					parent.interact($PlayerCharacter)
					break
	if event.is_action_pressed("M"):
		Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn")
	if event.is_action_pressed("1"):
		test()

func test():
	var v:Array[Vehicle]
	world_object.launch_convoy(world_object.vehicles,Global.world.world_objects.back())

func new_producer(producer:Producer):
	world_object.producers.append(producer)

func add_level_object(object:LevelObject) -> void:
	$LevelObjects.add_child(object)
	for producer in object.producers():
		new_producer(producer)

func remove_level_object(object:LevelObject):
	var to_be_erased:Array[Producer] = []
	for producer in world_object.producers:
		if producer.level_object_id == object.id:
			to_be_erased.append(producer)
	for i in to_be_erased:
		world_object.producers.erase(i)
	object.queue_free()

func _on_button_pressed():
	var placer = load("res://World/WorldObjects/BlueprintPlacer.tscn").instantiate()
	placer.init(load("res://Level/LevelObjects/LO_Test/LO_Test.tscn"))

func save():
	# What needs to be saved:
	# 	All LevelObjects
	var file_path:String = "user://" + "Level" + str(world_object.level_id) + ".save"
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	if save_file == null:
		return
	if not save_file.is_open():
		return
	for i in $LevelObjects.get_children():
		var data = i.save()
		var json_string = JSON.stringify(data)
		save_file.store_line(json_string)
	save_file.close()

func load_level(id:int) -> void:
	#return
	if id == 0:
		generate_level()
		return
	
	var file_path:String = "user://" + "Level" + str(world_object.level_id) + ".save"
	if not FileAccess.file_exists(file_path):
		state_machine.transition_to("Main")
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
		get_node(data["parent"]).add_child(new_object)

func generate_level() -> void:
	world_object.level_id = get_instance_id()
