extends LevelObject

func _name():
	return "Convoy Programmer"

func is_interaction_valid(_interactor) -> bool:
	return true

func interact(_interactor) -> void:
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module": "ConvoyProgrammer"})
