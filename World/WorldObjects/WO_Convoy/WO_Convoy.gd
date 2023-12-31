extends WorldObject

var origin:WorldObject = null
var destination:WorldObject = null

#var moving:bool = false
var timer:Timer
var path:PackedVector2Array = []
var path_index:int = 0
var max_speed:float = 0.0

signal moved_to(tile_coord:Vector2)
signal destination_reached

func name() -> String:
	return "Convoy"
	
func map_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Convoy/truck.png")

func info() -> PackedStringArray:
	var arr:PackedStringArray = [name()]
	if origin != null:
		arr.append(origin.name())
	if destination != null:
		arr.append(destination.name())
	return arr

func update()->void:
	return
	
func options()->Array[WorldObjectOption]:
	return [WorldObjectOption.new("Return To Origin"),
			#WorldObjectOption.new("Change Destination"),
			WorldObjectOption.new("Speed Boost"),
	]

func init_convoy(_vehicles:Array[Vehicle],_origin:WorldObject,_destination:WorldObject) -> void:
	vehicles = _vehicles
	origin = _origin
	world_position = origin.world_position
	max_speed = get_top_speed()
	timer = Global.world.create_timer()
	timer.timeout.connect(_on_move_timer_timeout)
	new_destination(_destination)

func new_destination(new_dest:WorldObject):
	# print("new destination: ", new_dest.name)
	timer.stop()
	destination = new_dest
	if destination.has_signal("moved_to"):
		destination.moved_to.connect(destination_moved)
	var tile_pos = Global.world.tilemap.local_to_map(world_position)
	var dest_tile_pos = Global.world.tilemap.local_to_map(destination.world_position)
	path = Global.world.astar.get_id_path(tile_pos, dest_tile_pos)
	# print("path: ", path)
	path_index = 0
	timer.start(max_speed)

func _on_move_timer_timeout():
	if path_index == path.size():
		_destination_reached()
		return
	world_position = Global.world.tilemap.map_to_local(path[path_index])
	emit_signal("moved")
	path_index += 1
	var speed = max_speed
	if path_index < path.size():
		speed += Global.world.get_custom_data("speed_modifier", path[path_index])
	timer.start(speed)
	
func get_top_speed()->float:
	# The convoy only moves as fast as its slowest vehicle
	#var lowest_speed = vehicles.front().speed()
	var lowest_speed = 1
	for i in vehicles:
		if i.speed() < lowest_speed:
			lowest_speed = i.speed()
	return lowest_speed

func _destination_reached()->void:
	path.clear()
	path_index = 0
	timer.queue_free()
	emit_signal("destination_reached")
	destination.add_vehicles(vehicles)
	Global.world.remove_world_object(self)

func destination_moved()->void:
	new_destination(destination)

func map_sprite()->Texture2D:
	# place each of the vehicles in formation. how? idk
	return load("res://World/WorldObjects/WO_Convoy/truck.png")

func option_chosen(option:WorldObjectOption)->void:
	print(option.option_name)
	if option.option_name == "Return To Origin":
		new_destination(origin)
	if option.option_name == "Speed Boost":
		pass
