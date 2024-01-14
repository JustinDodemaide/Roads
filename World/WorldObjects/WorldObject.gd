extends Resource
class_name WorldObject

var world_position:Vector2
var resources:Array[Item]
var producers:Array[Producer]
var storage:Dictionary
var vehicles:Array[Vehicle]

var level_id:int = 0 # A level id of 0 means a level must be generated for this object
var faction:String = "Unclaimed"

signal moved

func init(initial_faction:String,position:Vector2) -> void:
	faction = initial_faction
	world_position = position

func name() -> String:
	return "World Object"

func map_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Test/wo.png")

func info() -> PackedStringArray:
	var arr:PackedStringArray = [name()]
	for item in storage:
		var s = item + ": " + str(storage[item])
		arr.append(s)
	return arr

func update()->void:
	for producer in producers:
		for rate in producer.item_rates:
			var item_name = rate.item.item_name()
			if rate.slope < 0:
				# If producer needs an item to make something, and that item
				# isn't available, skip that producer.
				if not storage.has(item_name):
					break
				var required_amount = rate.slope * Global.WORLD_UPDATE_TIME
				if storage[item_name] < required_amount:
					break
			if not storage.has(item_name):
				storage[item_name] = 0
			storage[item_name] += rate.slope * Global.WORLD_UPDATE_TIME
	additional_updates()

func additional_updates() -> void:
	pass

func options()->Array[WorldObjectOption]:
	var o:Array[WorldObjectOption] = []
	o.append(WorldObjectOption.new("Launch Convoy"))
	
	if Global.player_location != self and faction == "PLAYER":
		o.append(WorldObjectOption.new("Go to Location"))
	return o

func option_chosen(option:WorldObjectOption) -> void:
	var s = self
	if option.option_name == "Go to Location":
		Global.scene_handler.transition_to("res://Level/Level.tscn",{"WorldObject":s})

func add_production(producer:Producer) -> void:
	producers.append(producer)

func add_vehicles(new_vehicles:Array[Vehicle]) -> void:
	vehicles.append_array(new_vehicles)

func launch_convoy(v:Array[Vehicle],destination:WorldObject)->void:
	#print("launching convoy")
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new(faction)
	Global.world.add_world_object(convoy)
	convoy.init_convoy(v,self,destination)

func save() -> Dictionary:
# world_position
# producers
# storage
# vehicles
# level_id
# faction
	var data = {"what": "WorldObject",
				"world_position": var_to_str(world_position),
				"level_id":level_id,
				"faction":faction,
				"resources":[],
				"producers":[],
				"storage":storage,
				"vehicles":[],
				"player_location":false
	}
	for i in resources:
		data["resources"].append(i.save())
	for i in producers:
		data["producers"].append(i.save())
	for i in vehicles:
		data["vehicles"].append(i.save())
	if Global.player_location == self:
		data["player_location"] = true
	
	return data

func _load(data:Dictionary) -> void:
	world_position = str_to_var(data["world_position"])
	level_id = data["level_id"]
	faction = data["faction"]
	for save_data in data["resources"]:
		resources.append(load(save_data["path"]).new())
	for save_data in data["producers"]:
		producers.append(Producer.new([],0,save_data))
	for save_data in data["vehicles"]:
		var vehicle = load(save_data["path"]).new()
		vehicle._load(save_data)
		vehicles.append(vehicle)
		
	storage = data["storage"]
	if data["player_location"]:
		Global.player_location = self
