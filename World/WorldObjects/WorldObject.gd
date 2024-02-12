extends Resource
class_name WorldObject

var world_position:Vector2
var resources:Array[Item]
var producers:Array[Producer]
var storage:Dictionary
var vehicles:Array[Vehicle]
var characters:Array[Character]
var level_id:int

var mission_id:int = 0
var faction:Faction = null
var ai_info:AI_Info = AI_Info.new()

signal moved

func _init():
	Global.world.next_turn.connect(update)

func init(position:Vector2) -> void:
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

func update(_who = null)->void:
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

func add_production(producer:Producer) -> void:
	producers.append(producer)

func add_vehicles(new_vehicles:Array[Vehicle]) -> void:
	vehicles.append_array(new_vehicles)
	ai_info.update()

func launch_convoy(v:Array[Vehicle],destination:WorldObject)->void:
	#print("launching convoy")
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new(faction)
	Global.world.add_world_object(convoy)
	convoy.init_convoy(v,self,destination)
	ai_info.update()

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
				"faction":null,
				"resources":[],
				"producers":[],
				"storage":storage,
				"vehicles":[],
				"player_location":false
	}
	if faction != null:
		data["faction"] = faction.id
	for i in resources:
		data["resources"].append(i.save())
	for i in producers:
		data["producers"].append(i.save())
	for i in vehicles:
		data["vehicles"].append(i.save())
	
	return data

func _load(data:Dictionary) -> void:
	world_position = str_to_var(data["world_position"])
	var id = data["faction"]
	if id != null:
		faction = Global.world.factions[data["faction"]]
	level_id = data["level_id"]
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
