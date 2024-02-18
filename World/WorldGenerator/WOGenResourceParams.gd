extends RefCounted
class_name WG_RP
# WorldGen ResourceParameters

var item_name:String
var percent_chance
#var current:int = 0
#var max:int

func _init(_item_name:String,percent:float):
	item_name = _item_name
	percent_chance = percent
	#max = round((percent / 100.0) * world_generator.OBJECTS_PER_ZONE_MULTIPLIER * world_generator.OBJECTS_PER_ZONE_RATIOS[zone])
	#pass
	
# Percent: How many objects per zone could potentially have this resource
# (percent() / 100) * OBJECTS_PER_ZONE_MULTIPLIER == max
# Ex. OBJECTS_PER_ZONE_MULTIPLIER = 75, percent = 50
# (50 / 100) * 75 = ~38. 38 out of 75 of the WorldObjects will be given this
# resource. Refer to WorldGenerator.place_object() for how this works
