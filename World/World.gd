extends Node

const FLOOR_LAYER:int = 0

signal world_ready
signal new_object(world_object)
signal removed_object(world_object)

var world_objects:Array[WorldObject]

@onready var astar = AStarGrid2D.new()
@onready var tilemap:TileMap = $TileMap
@onready var world_update:Timer = $WorldUpdate

func _ready():
	Global.world = self
	var test = load("res://World/WorldObjects/WO_Test/WO_Test.gd").new("PLAYER")
	world_objects.append(test)
	for i in 5:
		var test1 = load("res://World/WorldObjects/WO_Resource_Test/WO_Resource_Test.gd").new("PLAYER")
		test1.world_position = Vector2(21,156) + Vector2(i*100,0)
		world_objects.append(test1)
	
	initialize_astar()
	$WorldUpdate.start(Global.WORLD_UPDATE_TIME)
	emit_signal("world_ready")

func initialize_astar() -> void:
	astar.size = Vector2i(255,255)
	astar.cell_size = Vector2(16, 16)
	#astar.set_jumping_enabled(true)
	astar.update()
	for coord in $TileMap.get_used_cells(FLOOR_LAYER):
		var cell_data = $TileMap.get_cell_tile_data(FLOOR_LAYER, coord)
		var speed_modifier = cell_data.get_custom_data("speed_modifier")
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
	return data.get_custom_data(data_name)

func save() -> void:
	pass

func _load() -> void:
	pass

func get_astar_path(from:WorldObject,to:WorldObject) -> PackedVector2Array:
	var from_tile = $TileMap.local_to_map(from.world_position)
	var to_tile = $TileMap.local_to_map(to.world_position)
	return astar.get_point_path(from_tile,to_tile)
