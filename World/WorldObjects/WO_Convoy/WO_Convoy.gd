extends WorldObject

var origin:WorldObject = null
var current_location:WorldObject = null

var actions:Array
var num_actions:int
var action_index:int = -1

var max_speed:float = 1.0

func name() -> String:
	return "Convoy"
	
func map_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Convoy/truck.png")

func update():
	return

func init_convoy(_vehicles:Array[Vehicle],_origin:WorldObject,_actions:Array) -> void:
	vehicles = _vehicles
	origin = _origin
	for i in vehicles:
		origin.vehicles.erase(i)
	current_location = _origin
	actions = _actions
	num_actions = actions.size()
	Global.world.add_world_object(self)
	get_next_action()

func get_next_action() -> void:
	action_index += 1
	if action_index == num_actions:
		action_index = 0
	var action = actions[action_index]
	action.complete.connect(action_complete)
	action.execute(self)

func action_complete() -> void:
	actions[action_index].complete.disconnect(action_complete)
	get_next_action()

func save() -> Dictionary:
	var data = {"what": "Convoy",
				"world_position": var_to_str(world_position),
				"faction":faction,
				"storage":storage,
				"vehicles":[],
				"current_location":null,
				# For saving and loading specific world objects:
				# could take advantage of the fact they're all stored in an
				# array? Just save the index of the WO, and use the index
				# to retrieve it when loading
				"actions":[],
				"action_index":action_index,
	}
	for i in vehicles:
		data["vehicles"].append(i.save())
	if current_location != null:
		data["current_location"] = var_to_str(current_location.world_position)
	for i in actions:
		data["actions"].append(i.save())
		# Problem: each action has their own init parameters, so calling '.new()'
		# on the path isnt going to work 
	return data

func _load(data:Dictionary) -> void:
	world_position = str_to_var(data["world_position"])
	faction = data["faction"]
	storage = data["storage"]
	for save_data in data["vehicles"]:
		var vehicle = load(save_data["path"]).new()
		vehicle._load(save_data)
		vehicles.append(vehicle)
	if data["current_location"] != null:
		var pos = str_to_var(data["current_location"])
		# Yeah this sucks
		# HACK
		for i in Global.world.world_objects:
			if i.world_position == pos:
				current_location = pos
				break
		
	for save_data in data["actions"]:
		var action = load(save_data["path"]).new()
		action._load(save_data)
		actions.append(action)
	num_actions = actions.size()
	action_index = data["action_index"] - 1
	get_next_action()
