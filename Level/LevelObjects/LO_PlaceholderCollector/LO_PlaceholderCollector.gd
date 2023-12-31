extends LevelObject

func _name():
	return "Placeholder Collector"

func is_interaction_valid(_interactor) -> bool:
	return true

func interact(_interactor) -> void:
	pass

func producers() -> Array[Producer]:
	var item = Global.player_location.resources.front()
	var rate = ItemRate.new(item,1)
	return [Producer.new([rate],id)]
