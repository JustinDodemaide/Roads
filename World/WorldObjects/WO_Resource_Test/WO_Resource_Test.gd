extends WorldObject

func name() -> String:
	return "Waffle"

func map_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Resource_Test/Waffle.png")

func update()->void:
	pass

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

func launch_convoy(vehicles:Array[Vehicle],destination:WorldObject)->void:
	#print("launching convoy")
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
	Global.world.add_world_object(convoy)
	convoy.init(vehicles,self,destination)
