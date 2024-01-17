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
	}
	for i in vehicles:
		data["vehicles"].append(i.save())
	return data

func _load(data:Dictionary) -> void:
	world_position = str_to_var(data["world_position"])
	faction = data["faction"]
	for save_data in data["vehicles"]:
		var vehicle = load(save_data["path"]).new()
		vehicle._load(save_data)
		vehicles.append(vehicle)
	storage = data["storage"]
