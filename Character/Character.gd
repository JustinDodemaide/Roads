extends RefCounted
class_name Character

var name:String = "Character"
var faction:Faction

var equip_slots:int = 1
var equipment:Array[String] = []
var utility_slots:int = 2
var utilities:Array[String] = ["Waffle"]

func _load(data:Dictionary) -> void:
	name = data["name"]

func save() -> Dictionary:
	return {"name":name,
	}

func set_utilities(items:Array[String]) -> void:
	utilities = items
