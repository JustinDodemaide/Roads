extends LevelObject

func name() -> String:
	return "Test"

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	return true

func interact(interactor) -> void:
	pass

func _on_area_2d_area_entered(area):
	if area.get_parent() is PlayerCharacter:
		pass

func components() -> Dictionary:
	#{item: amount}
	return {"Waffle": 1}

func producers() -> Array[Producer]:
	var rate = ItemRate.new("Waffle",1)
	return [Producer.new([rate])]
