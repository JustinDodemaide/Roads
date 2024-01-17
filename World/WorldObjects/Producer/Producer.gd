class_name Producer

var item_rates:Array[ItemRate]
var level_object_id:int

func _init(rates:Array[ItemRate], id:int, load_data:Dictionary = {}):
	if load_data != {}:
		level_object_id = load_data["id"]
		for rate_data in load_data["rates"]:
			var item = load(rate_data["item"]).new()
			var slope = rate_data["slope"]
			var rate = ItemRate.new(item,slope)
			item_rates.append(rate)
	else:
		item_rates = rates
		level_object_id = id

func save() -> Dictionary:
	var data = {"rates":[],"id":level_object_id}
	var rates = []
	for item_rate in item_rates:
		# Just save the path instead of {"path":path}, makes things simpler
		var item_path = item_rate.item.save()["path"]
		var rate_data = {"item":item_path,"slope":item_rate.slope}
		rates.append(rate_data)
	data["rates"] = rates
	return data
