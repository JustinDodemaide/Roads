extends RefCounted
class_name Character

var name:String = "Character"
var equip_slots:int = 2

func _load(data:Dictionary) -> void:
	name = data["name"]

func save() -> Dictionary:
	return {"name":name,
	}
