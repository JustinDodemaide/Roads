extends WorldObject

var origin:WorldObject = null

var actions:Array
var action_index:int = 0

func name() -> String:
	return "Convoy"
	
func map_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Convoy/truck.png")

func update():
	return

func init_convoy(vehicles:Array[Vehicle],_actions:Array) -> void:
	pass

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
