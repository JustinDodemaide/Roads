extends RefCounted
class_name ConvoyStop

var location:WorldObject
var items_to_deposit:Dictionary
var items_to_collect:Dictionary

func _init(_location:WorldObject,deposit:Dictionary = {},collect:Dictionary = {})->void:
	location = _location
	items_to_deposit = deposit
	items_to_collect = collect

func save() -> Dictionary:
	return {
		"location":location,
		"deposit":items_to_deposit,
		"collect":items_to_collect
	}
