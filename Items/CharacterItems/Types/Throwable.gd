extends CharacterItem
class_name CharacterItem_Throwable

@export_range(1,9,2) var force:int = 5

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	#for i in _selection_info["cleanup"]:
	#	i.queue_free()
	var throwable = load("res://Mission/MissionObjects/Throwable/Throwable.tscn").instantiate()
	throwable.set_force(_selection_info["force"])
	throwable.init(_actor.position,_selection_info["position"])
	emit_signal("complete")
