extends RefCounted
class_name WO_ResourceParams

var item_path:String
var current:int = 0
var max:int

func _init(_item_path:String,percent:int,objects_per_zone):
	item_path = _item_path
	max = (percent / 100) * objects_per_zone

# Percent: How many objects per zone could potentially have this resource
# (percent() / 100) * OBJECTS_PER_ZONE_MULTIPLIER == max
# Ex. OBJECTS_PER_ZONE_MULTIPLIER = 75, percent = 50
# (50 / 100) * 75 = ~38. 38 out of 75 of the WorldObjects will be given this
# resource. Refer to WorldGenerator.place_object() for how this works
