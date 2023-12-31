extends Node

# Level

var world_object:WorldObject
var tileset_prefab:int

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["WorldObject"]
	if world_object.level_id == 0:
		generate_level()
	Global.level = self
	Global.player_location = world_object
	load_level(world_object.level_id)
	
	add_child(load("res://Level/PlayerCharacter/PlayerCharacter.tscn").instantiate())
	$PlayerCharacter.position = $TileMap.get_node("PlayerStart").position
	var pickaxe = load("res://Items/Pickaxe/Item_Pickaxe.gd").new()
	make_dropped_item(ItemStack.new(pickaxe),$PlayerCharacter.position + Vector2(0,100))

func exit()->void:
	save()

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("M"):
		Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn")
	if event.is_action_pressed("1"):
		test()

func test():
	var _v:Array[Vehicle]
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

func save():
	# What needs to be saved:
	# 	All LevelObjects
	var file_path:String = "user://" + "Level" + str(world_object.level_id) + ".save"
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	if save_file == null:
		return
	if not save_file.is_open():
		return
	
	var tilemap_data = $TileMap.save()
	tilemap_data = JSON.stringify(tilemap_data)
	save_file.store_line(tilemap_data)
	
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

func generate_level() -> void:
	world_object.level_id = get_instance_id()
	var level_prefab:int
	# DEBUG /*
	level_prefab = 1
	if world_object.name() == "Waffle":
		level_prefab = 2
	# */ DEBUG END
	world_object.level_id = level_prefab
	var tilemap = load("res://Level/TileMapPrefabs/LTM_" + str(level_prefab) + ".tscn").instantiate()
	tilemap._load({})
	add_child(tilemap)


func _on_button_pressed():
	var placer = load("res://World/WorldObjects/BlueprintPlacer.tscn").instantiate()
	placer.init(load("res://Level/LevelObjects/LO_Test/LO_Test.tscn"))

func _on_button_2_pressed():
	var placer = load("res://World/WorldObjects/BlueprintPlacer.tscn").instantiate()
	placer.init(load("res://Level/LevelObjects/LO_Terminal/LO_Terminal.tscn"))

func _on_pickaxe_pressed():
	var item = load("res://Items/Pickaxe/Item_Pickaxe.gd").new()
	var pickaxe = ItemStack.new(item)
	$PlayerCharacter.carry_item(pickaxe)

func make_dropped_item(item_stack:ItemStack,pos:Vector2) -> void:
	var dropped_item = load("res://Level/LevelObjects/LO_DroppedItem/LO_DroppedItem.tscn").instantiate()
	dropped_item.init(item_stack)
	dropped_item.position = pos
	add_level_object(dropped_item)
