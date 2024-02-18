extends RefCounted
class_name WO_Resource

var item_name:String
var production_tier:int = -1
const production_rates:PackedFloat32Array = [1, 2, 3]
const max_tiers:int = 2

func _init(item:String, load_data:Dictionary = {}):
	if not load_data.is_empty():
		item_name = load_data["item"]
		production_tier = load_data["tier"]
		return
	item_name = item

func update(wo:WorldObject) -> void:
	var quantity = production_rates[production_tier]
	if wo.storage.has(item_name):
		wo.storage[item_name] += quantity
	else:
		wo.storage[item_name] = quantity

func save() -> Dictionary:
	return {"item":item_name,
			"tier":production_tier
	}
