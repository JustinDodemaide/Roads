extends WorldObject

var circuit:bool = false
var stops:Array[ConvoyStop]
var stops_index:int = 1

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

func init_convoy(_vehicles:Array[Vehicle],_stops:Array[ConvoyStop],_circuit:bool = false) -> void:
	vehicles = _vehicles
	stops = _stops
	origin = _stops.front().location
	world_position = origin.world_position
	circuit = _circuit
	max_speed = get_top_speed()
	timer = Global.world.create_timer()
	timer.timeout.connect(_on_move_timer_timeout)
	Global.world.add_world_object(self)
	new_destination(stops[stops_index])

#func init_convoy_circuit(_vehicles:Array[Vehicle],_origin:WorldObject,program_stops:Array[ConvoyStop]) -> void:
	#stops = program_stops
	#origin = _origin
	#world_position = origin.world_position
	#max_speed = get_top_speed()
	#timer = Global.world.create_timer()
	#timer.timeout.connect(_on_move_timer_timeout)
	#Global.world.add_world_object(self)
	#new_destination(stops.front())

func new_destination(new_dest:ConvoyStop):
	# print("new destination: ", new_dest.name)
	timer.stop()
	destination = new_dest
	if destination.has_signal("moved_to"):
		destination.moved_to.connect(destination_moved)
	var tile_pos = Global.world.tilemap.local_to_map(world_position)
	var dest_tile_pos = Global.world.tilemap.local_to_map(destination.location.world_position)
	path = Global.world.astar.get_id_path(tile_pos, dest_tile_pos)
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

func _destination_reached() -> void:
	if destination.location.faction == Global.UNCLAIMED_FACTION:
		Global.world.claim_world_object(destination.location,faction)
	transfer_items()
	
	stops_index += 1
	if stops_index == stops.size():
		stops_index = 0
	if stops_index == 0 and not circuit:
		end_convoy()
		return
	new_destination(stops[stops_index])

func transfer_items() -> void:
	pass
	# Deposit first
	var stop = stops[stops_index]
	var stop_storage = stop.location.storage
	for item in stop.items_to_deposit:
		if not storage.has(item):
			# Halt
			return
		var amount = stop.items_to_deposit[item]
		if storage[item] < amount:
			# Problem, bc the convoy should have the items by this point
			return
		storage[item] -= amount
		if stop_storage.has(item):
			stop_storage[item] += amount
		else:
			stop_storage[item] = amount
	
	# Collect next
	for item in stop.items_to_collect:
		if not stop_storage.has(item):
			# Halt
			return
		var amount = stop.items_to_collect[item]
		if stop_storage[item] < amount:
			# Halt
			return
		stop_storage[item] -= amount
		if storage.has(item):
			storage[item] += amount
		else:
			storage[item] = amount

func end_convoy() -> void:
	stops[stops_index].location.add_vehicles(vehicles)
	Global.world.remove_world_object(self)

#func _destination_reached()->void:
	#path.clear()
	#path_index = 0
	#if destination.location.faction == Global.UNCLAIMED_FACTION:
		#Global.world.claim_world_object(destination.location,faction)
	#if stops.is_empty():
		#timer.queue_free()
		#emit_signal("destination_reached")
		#destination.location.add_vehicles(vehicles)
		#Global.world.remove_world_object(self)
	#else:
		#var stop = stops[stops_index]
		#for i in stop.items_to_deposit:
			#if stop.location.storage.has(i):
				#stop.location.storage[i] += storage[i]
			#else:
				#stop.location.storage[i] = storage[i]
			#storage.erase(i)
		#for i in stop.items_to_collect:
			#pass
		#stops_index += 1
		#if stops_index == stops.size():
			#stops_index = 0
		#new_destination(stops[stops_index])

func get_top_speed()->float:
	# The convoy only moves as fast as its slowest vehicle
	#var lowest_speed = vehicles.front().speed()
	var lowest_speed = 1
	for i in vehicles:
		if i.speed() < lowest_speed:
			lowest_speed = i.speed()
	return lowest_speed

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

func save() -> Dictionary:
# world_position
# producers
# storage
# vehicles
# faction
	var data = {"what": "Convoy",
				"world_position": var_to_str(world_position),
				"faction":faction,
				"storage":storage,
				"vehicles":[],
				"path":path,
				"path_index":path_index,
				"stops":[],
				"stops_index":stops_index
	}
	for i in vehicles:
		data["vehicles"].append(i.save())
	for i in path:
		data["stops"].append(var_to_str(i))
	for i in stops:
		data["stops"].append(i.save())
	return data

func _load(data:Dictionary) -> void:
	world_position = str_to_var(data["world_position"])
	faction = data["faction"]
	for save_data in data["vehicles"]:
		var vehicle = load(save_data["path"]).new()
		vehicle._load(save_data)
		vehicles.append(vehicle)
	for stop in data["stops"]:
		stops.append(ConvoyStop.new(stop["location"],stop["deposit"],stop["collect"]))
	stops_index = data["stops_index"]
	for point in data["path"]:
		path.append(str_to_var(point))
	path_index = data["path_index"]
	storage = data["storage"]
