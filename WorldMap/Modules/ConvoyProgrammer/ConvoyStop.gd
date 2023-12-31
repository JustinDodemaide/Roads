extends RefCounted
class_name ConvoyStop

var destination:WorldObject
var items_consumed:Array[ItemStack]
var items_to_deposit:Array[ItemStack]
var items_to_collect:Array[ItemStack]

func _init(location:WorldObject):
	destination = location
