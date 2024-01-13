extends WorldObject

var stops:Array[ConvoyStop]
var stops_index:int = 0

var origin:WorldObject = null
var destination:ConvoyStop = null

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

func init_convoy_oneshot(_vehicles:Array[Vehicle],_origin:WorldObject,_destination:ConvoyStop) -> void:
	vehicles = _vehicles
	origin = _origin
	world_position = origin.world_position
	max_speed = get_top_speed()
	timer = Global.world.create_timer()
	timer.timeout.connect(_on_move_timer_timeout)
	Global.world.add_world_object(self)
	new_destination(_destination)

func init_convoy_circuit(_vehicles:Array[Vehicle],_origin:WorldObject,program_stops:Array[ConvoyStop]) -> void:
	stops = program_stops
	origin = _origin
	world_position = origin.world_position
	max_speed = get_top_speed()
	timer = Global.world.create_timer()
	timer.timeout.connect(_on_move_timer_timeout)
	Global.world.add_world_object(self)
	new_destination(stops.front())

func new_destination(new_dest:ConvoyStop):
	# print("new destination: ", new_dest.name)
	timer.stop()
	destination = new_dest
	if destination.has_signal("moved_to"):
		destination.moved_to.connect(destination_moved)
	var tile_pos = Global.world.tilemap.local_to_map(world_position)
	var dest_tile_pos = Global.world.tilemap.local_to_map(destination.location.world_position)
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
		var speed_modifier = Global.world.get_custom_data("speed_modifier", path[path_index])
		if speed_modifier == null:
			speed_modifier = 0
		speed += speed_modifier
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
	if destination.location.faction == "Unclaimed":
		Global.world.claim_world_object(destination.location,faction)
	if stops.is_empty():
		timer.queue_free()
		emit_signal("destination_reached")
		destination.location.add_vehicles(vehicles)
		Global.world.remove_world_object(self)
	else:
		stops_index += 1
		if stops_index == stops.size():
			stops_index = 0
		new_destination(stops[stops_index])

func destination_moved()->void:
	new_destination(destination)

func map_sprite()->Texture2D:
	# place each of the vehicles in formation
	return load("res://World/WorldObjects/WO_Convoy/truck.png")

func option_chosen(option:WorldObjectOption)->void:
	print(option.option_name)
	if option.option_name == "Return To Origin":
		new_destination(ConvoyStop.new(origin))
	if option.option_name == "Speed Boost":
		pass
