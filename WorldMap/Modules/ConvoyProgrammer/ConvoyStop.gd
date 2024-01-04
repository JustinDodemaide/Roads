extends RefCounted
class_name ConvoyStop

var destination:WorldObject
var items_to_deposit:Dictionary
var items_to_collect:Dictionary

func _init(location:WorldObject,deposit:Dictionary = {},collect:Dictionary = {})->void:
	destination = location
	items_to_deposit = deposit
	items_to_collect = collect
