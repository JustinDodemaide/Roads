extends WorldObject

func name() -> String:
	return "Waffle"

func map_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Resource_Test/Waffle.png")

func update()->void:
	pass

func additional_updates() -> void:
	pass

func add_production(producer:Producer) -> void:
	producers.append(producer)

func add_vehicles(new_vehicles:Array[Vehicle]) -> void:
	vehicles.append_array(new_vehicles)
