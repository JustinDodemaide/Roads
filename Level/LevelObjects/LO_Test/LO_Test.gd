extends LevelObject

func name() -> String:
	return "Test"

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	return true

func interact(interactor) -> void:
	var world_object = Global.level.world_object
	var v:Array[Vehicle]
	world_object.launch_convoy(world_object.vehicles,Global.world.world_objects.back())
