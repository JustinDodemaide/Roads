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

var halted:bool = false
var halted_reason:int
enum HALT_REASONS{AWAITING_COLLECTION}

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
	for vehicle in vehicles:
		origin.vehicles.erase(vehicle)
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
	path = Global.world.get_astar_path(self, destination.location)
	path_index = 0
	timer.start(max_speed)

func _on_move_timer_timeout():
	if path_index == path.size():
		_destination_reached()
		return
	world_position = path[path_index]
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
	var items_transfered = transfer_items()
	if not items_transfered:
		halt(HALT_REASONS.AWAITING_COLLECTION)
		return
	stops_index += 1
	if stops_index == stops.size():
		stops_index = 0
	if stops_index == 0 and not circuit:
		end_convoy()
		return
	new_destination(stops[stops_index])

func transfer_items() -> bool:
	# Deposit first
	var stop = stops[stops_index]
	var stop_storage = stop.location.storage
	for item in stop.items_to_deposit:
		if not storage.has(item):
			# Problem, bc the convoy should have the items by this point
			return false
		var amount = stop.items_to_deposit[item]
		if storage[item] < amount:
			# Problem, bc the convoy should have the items by this point
			return false
		storage[item] -= amount
		if stop_storage.has(item):
			stop_storage[item] += amount
		else:
			stop_storage[item] = amount
	
	# Collect next
	for item in stop.items_to_collect:
		if not stop_storage.has(item):
			# Halt
			return false
		var amount = stop.items_to_collect[item]
		if stop_storage[item] < amount:
			# Halt
			return false
		stop_storage[item] -= amount
		if storage.has(item):
			storage[item] += amount
		else:
			storage[item] = amount
	return true

func halt(reason:int) -> void:
	halted_reason = reason
	Global.world.world_update.timeout.connect(update_halt_status)

func update_halt_status() -> void:
	var unhalt:bool = false
	match halted_reason:
		HALT_REASONS.AWAITING_COLLECTION:
			var stop_storage = stops[stops_index].location.storage
			var items_to_collect = stops[stops_index].items_to_collect
			var needed_items = {}
			for item in items_to_collect:
				var needed_amount = items_to_collect[item] - storage[item]
				if needed_amount < 0:
					continue
				needed_items[item] = needed_amount
			for item in stop_storage:
				if stop_storage[item] >= needed_items[item]:
					stop_storage[item] -= needed_items[item]
					storage[item] += needed_items[item]
					needed_items.erase(item)
			if needed_items.is_empty():
				unhalt = true
	if unhalt:
		Global.world.world_update.timeout.disconnect(update_halt_status)
		halted = false
		stops_index += 1
		if stops_index == stops.size():
			stops_index = 0
		if stops_index == 0 and not circuit:
			end_convoy()
			return
		new_destination(stops[stops_index])

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
		data["path"].append(var_to_str(i))
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
		# Using the position as the unique identifier to get the WO for a stop
		# Works if the stop location is a WorldObject bc they'll all be loaded
		# in at this point. Does not work if the stop location is a Convoy that hasn't been loaded
		# yet
		var stop_position = str_to_var(stop)
		var location:WorldObject = null
		for loc in Global.world.world_objects:
			if loc.world_position == stop_position:
				location = loc
				break
		if location == null:
			# Problem
			return
		stops.append(ConvoyStop.new(location,stop["deposit"],stop["collect"]))
	stops_index = data["stops_index"]
	for point in data["path"]:
		path.append(str_to_var(point))
	path_index = data["path_index"]
	storage = data["storage"]
