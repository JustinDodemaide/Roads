extends Resource
class_name WorldObject

var world_position:Vector2
var resources:Array[WO_Resource]
var vehicles:Array[Vehicle]
var characters:Array[Character] = [Character.new()]
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
	return load("res://World/placeholder.png")

func update(faction_whose_turn_it_is:Faction)->void:
	if not faction_whose_turn_it_is == faction:
		return
	for resource in resources:
		resource.update(self)
	additional_updates()

func additional_updates() -> void:
	pass

func add_vehicles(new_vehicles:Array[Vehicle]) -> void:
	vehicles.append_array(new_vehicles)
	ai_info.update()

func remove_characters(to_remove:Array[Character]) -> void:
	for character in to_remove:
		characters.erase(character)
	ai_info.update()

func add_characters(new_characters:Array[Character]) -> void:
	characters.append_array(new_characters)
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
				"vehicles":[],
				"player_location":false
	}
	if faction != null:
		data["faction"] = faction.id
	for i in resources:
		data["resources"].append(i.save())
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
		resources.append(WO_Resource.new("",save_data))
	for save_data in data["vehicles"]:
		var vehicle = load(save_data["path"]).new()
		vehicle._load(save_data)
		vehicles.append(vehicle)
		
	if data["player_location"]:
		Global.player_location = self
