extends ConvoyAction
# TransferItems

var convoy
var items_to_consume:Dictionary

func _init(items:Dictionary = {},consume:Dictionary = {}):
	items_to_consume = consume

func execute(_convoy:WorldObject) -> void:
	convoy = _convoy
	var storage = convoy.storage
	var location = convoy.current_location
	var location_storage = location.storage

	for item in items_to_consume:
		if not location_storage.has(item):
			halt()
			return
		var amount = items_to_consume[item]
		if location_storage[item] < amount:
			halt()
			return
		location_storage[item] -= amount

	emit_signal("complete")

func halt() -> void:
	Global.world.world_update.timeout.connect(update_halt)

func update_halt() -> void:
	var location_storage = convoy.current_location.storage
	var needed_items = {}
	for item in items_to_consume:
		var needed_amount = items_to_consume[item] - convoy.storage[item]
		if needed_amount < 0:
			continue
		needed_items[item] = needed_amount
	for item in location_storage:
		if location_storage[item] >= needed_items[item]:
			location_storage[item] -= needed_items[item]
			needed_items.erase(item)
	if needed_items.is_empty():
		Global.world.world_update.timeout.disconnect(update_halt)
		emit_signal("complete")

func save() -> Dictionary:
	return {"path":"res://World/WorldObjects/WO_Convoy/ConvoyActions/TransferItems.gd", "consume":items_to_consume}

func _load(_data) -> void:
	items_to_consume = _data["consume"]
