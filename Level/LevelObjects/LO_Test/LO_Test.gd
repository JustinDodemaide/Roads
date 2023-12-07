extends LevelObject

func name() -> String:
	return "Test"

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	return true

func interact(interactor) -> void:
	Global.level.remove_level_object(self)

func components() -> Dictionary:
	#{item: amount}
	return {"Waffle": 1}

func producers() -> Array[Producer]:
	var rate = ItemRate.new("Waffle",1)
	return [Producer.new([rate], id)]
