extends ConvoyAction

func execute(convoy:WorldObject) -> void:
	convoy.current_location.add_vehicles(convoy.vehicles)
	Global.world.remove_world_object(convoy)

func save() -> Dictionary:
	return {"path":"res://World/WorldObjects/WO_Convoy/ConvoyActions/End.gd"}

func _load(data):
	pass
