extends Node

const FLOOR_LAYER:int = 0

signal world_ready
signal new_object(world_object)
signal removed_object(world_object)

var world_objects:Array[WorldObject]
var factions:Dictionary

@onready var astar = AStarGrid2D.new()
@onready var tilemap:TileMap = $TileMap
@onready var world_update:Timer = $WorldUpdate

func _ready():
	Global.world = self
	if StartGameParameters.save == 0:
		StartGameParameters.save = StartGameParameters.num_saves + 1
		new_world()
		add_default_research_projects()
	else:
		_load()
	
	initialize_astar()
	$WorldUpdate.start(Global.WORLD_UPDATE_TIME)
	emit_signal("world_ready")

func initialize_astar() -> void:
	astar.size = Vector2i(300,300)
	astar.cell_size = Vector2(16, 16)
	#astar.set_jumping_enabled(true)
	astar.update()
	for coord in $TileMap.get_used_cells(FLOOR_LAYER):
		var cell_data = $TileMap.get_cell_tile_data(FLOOR_LAYER, coord)
		var speed_modifier = cell_data.get_custom_data("speed_modifier")
		if cell_data.get_custom_data("impass"):
			astar.set_point_solid(coord)
		# if the tile is an impass, astar.set_point_solid(coord)
		astar.set_point_weight_scale(coord, speed_modifier)

func _on_world_update_timeout():
	for object in world_objects:
		object.update()
	$WorldUpdate.start(Global.WORLD_UPDATE_TIME)
	
func add_world_object(object:WorldObject) -> void:
	world_objects.append(object)
	emit_signal("new_object", object)

func remove_world_object(object:WorldObject) -> void:
	world_objects.erase(object)
	emit_signal("removed_object", object)

func create_timer() -> Timer:
	var timer = Timer.new()
	add_child(timer)
	return timer

func _input(event):
	if event.is_action_pressed("F1"):
		print($TileMap.get_global_mouse_position())

func get_custom_data(data_name:String, tile:Vector2i):
	var data = tilemap.get_cell_tile_data(FLOOR_LAYER,tile)
	if data == null:
		return null
	return data.get_custom_data(data_name)

func save() -> void:
	# World objects
	# Tilemap
	# World time
	# Player money
	# Player location
	# AI
	var file_path:String = "user://" + "Save" + str(StartGameParameters.save) + ".save"
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	if save_file == null:
		return
	if not save_file.is_open():
		return
	
	# Tilemap
	# Potential optimization: just save the tiles that have been modified by the
	# player, then save the seed for the tilemap, and generate it from that seed
	# every time the game is started
	var tilemap_data:Dictionary = {"what":"TileMap"}
	for cell in $TileMap.get_used_cells(0):
		tilemap_data[var_to_str(cell)] = var_to_str(tilemap.get_cell_atlas_coords(0,cell))
	save_file.store_line(JSON.stringify(tilemap_data))
	
	# Factions
	for i in factions:
		save_file.store_line(JSON.stringify(factions[i].save()))
	
	# World objects
	for object in world_objects:
		var object_data = object.save()
		save_file.store_line(JSON.stringify(object_data))
	
	save_file.close()
	print("Save successful.")

func _load() -> void:
	# World objects
	# Tilemap
	# World time
	# Player money
	# AI
	
	var file_path:String = "user://" + "Save" + str(StartGameParameters.save) + ".save"
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
		if data["what"] == "Faction":
			var faction = Faction.new()
			faction._load(data)
			factions[data["name"]] = faction
		if data["what"] == "WorldObject":
			var object = WorldObject.new()
			object._load(data)
			world_objects.append(object)
		if data["what"] == "Convoy":
			var object = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
			object._load(data)
			world_objects.append(object)
		if data["what"] == "TileMap":
			data.erase("what")
			for cell in data:
				#cell = "Vector2i" + str_to_var(cell)
				$TileMap.set_cell(0,str_to_var(cell),0,str_to_var(data[cell]))
			continue
	save_file.close()

func new_world() -> void:
	var world_generator = WorldGenerator.new()
	world_generator.execute(tilemap)

func add_default_research_projects():
	var file_path:String = "user://" + str(StartGameParameters.save) + "ResearchedFacilities.save"
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	# Make sure to store the SCRIPT path, NOT the scene path
	save_file.store_line("res://Level/LevelObjects/LO_Tier0Harvester/LO_Tier0Harvester.gd")
	save_file.store_line("res://Level/LevelObjects/LO_VehicleBuilder/LO_VehicleBuilder.gd")
	save_file.store_line("res://Level/LevelObjects/LO_ConvoyProgrammer/LO_ConvoyProgrammer.gd")
	save_file.close()
	
	file_path = "user://" + str(StartGameParameters.save) + "ResearchedVehicles.save"
	save_file = FileAccess.open(file_path, FileAccess.WRITE)
	save_file.store_line("res://Vehicles/Vehicle_AllRounder.gd")
	save_file.close()

func get_astar_path(from:WorldObject,to:WorldObject) -> PackedVector2Array:
	var from_tile = $TileMap.local_to_map(from.world_position)
	var to_tile = $TileMap.local_to_map(to.world_position)
	return astar.get_point_path(from_tile,to_tile)

func claim_world_object(object:WorldObject,who:Faction) -> void:
	object.faction = who
