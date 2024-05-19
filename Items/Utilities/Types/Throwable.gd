extends CharacterItem
class_name CharacterItem_Throwable

@export_range(1,9,2) var force:int = 5
@export var effects:PackedStringArray = ["Fire"]

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	#for i in _selection_info["cleanup"]:
	#	i.queue_free()
	var throwable = load("res://Mission/MissionObjects/Throwable/Throwable.tscn").instantiate()
	throwable.set_force(_selection_info["force"])
	throwable.init(_actor.position,_selection_info["position"])
	await throwable.stopped_moving
	
	throwable.queue_free()
	var e:Array[Effect] = []
	for string in effects:
		e.append(Global.mission.string2effect(string))
	var effect_area = load("res://Mission/MissionObjects/EffectArea/EffectArea.tscn").instantiate()
	effect_area.init(throwable.position,e)
	
	emit_signal("complete")
