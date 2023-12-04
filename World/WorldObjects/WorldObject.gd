extends Resource
class_name WorldObject

var world_position:Vector2
var producers:Array[Producer]
var storage:Dictionary
var vehicles:Array[Vehicle]

var level_id:int = 0
# A level id of 0 means a level must be generated for this object

signal moved

func name() -> String:
	return "Test"

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
			if rate.slope < 0:
				# If producer needs an item to make something, and that item
				# isn't available, skip that producer.
				if not storage.has(rate.item):
					break
				var required_amount = rate.slope * Global.WORLD_UPDATE_TIME
				if storage[rate.item] < required_amount:
					break

			if not storage.has(rate.item):
				storage[rate.item] = 0
			storage[rate.item] += rate.slope * Global.WORLD_UPDATE_TIME
	additional_updates()

func additional_updates() -> void:
	pass

func options()->Array[WorldObjectOption]:
	return []

func option_chosen(option:WorldObjectOption) -> void:
	return

func add_production(producer:Producer) -> void:
	producers.append(producer)

func add_vehicles(new_vehicles:Array[Vehicle]) -> void:
	vehicles.append_array(new_vehicles)

func launch_convoy(v:Array[Vehicle],destination:WorldObject)->void:
	#print("launching convoy")
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
	Global.world.add_world_object(convoy)
	convoy.init(v,self,destination)

func generate_level() -> void:
	pass
