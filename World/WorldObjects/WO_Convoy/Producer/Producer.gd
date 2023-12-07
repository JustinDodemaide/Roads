class_name Producer

var item_rates:Array[ItemRate]
var level_object_id:int

func _init(rates:Array[ItemRate], id:int):
	item_rates = rates
	level_object_id = id
