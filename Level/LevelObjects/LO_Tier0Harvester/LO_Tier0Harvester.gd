extends LevelObject

func _name():
	return "Tier1 Harvester"

func is_interaction_valid(_interactor) -> bool:
	return true

func interact(_interactor) -> void:
	pass

func producers() -> Array[Producer]:
	var item = Global.player_location.resources.front()
	var rate = ItemRate.new(item,0.25)
	return [Producer.new([rate],id)]
