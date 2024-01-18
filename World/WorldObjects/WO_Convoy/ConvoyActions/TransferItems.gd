extends ConvoyAction
# TransferItems

var convoy
var items_to_deposit:Dictionary
var items_to_collect:Dictionary

func _init(deposit:Dictionary = {},collect:Dictionary = {}):
	items_to_deposit = deposit
	items_to_collect = collect

func execute(_convoy:WorldObject) -> void:
	convoy = _convoy
	# Deposit first
	var location = convoy.current_location
	var location_storage = location.storage
	var storage = convoy.storage
	for item in items_to_deposit:
		if not storage.has(item):
			# Problem, bc the convoy should have the items by this point
			return
		var amount = items_to_deposit[item]
		if storage[item] < amount:
			# Problem, bc the convoy should have the items by this point
			return
		storage[item] -= amount
		if location_storage.has(item):
			location_storage[item] += amount
		else:
			location_storage[item] = amount

	# Collect next
	for item in items_to_collect:
		if not location_storage.has(item):
			halt()
			return
		var amount = items_to_collect[item]
		if location_storage[item] < amount:
			halt()
			return
		location_storage[item] -= amount
		if storage.has(item):
			storage[item] += amount
		else:
			storage[item] = amount
	emit_signal("complete")

func halt() -> void:
	Global.world.world_update.timeout.connect(update_halt)

func update_halt() -> void:
	var location_storage = convoy.current_location.storage
	var needed_items = {}
	for item in items_to_collect:
		var needed_amount = items_to_collect[item] - convoy.storage[item]
		if needed_amount < 0:
			continue
		needed_items[item] = needed_amount
	for item in location_storage:
		if location_storage[item] >= needed_items[item]:
			location_storage[item] -= needed_items[item]
			convoy.storage[item] += needed_items[item]
			needed_items.erase(item)
	if needed_items.is_empty():
		Global.world.world_update.timeout.disconnect(update_halt)
		emit_signal("complete")

func save() -> Dictionary:
	return {"path":"res://World/WorldObjects/WO_Convoy/ConvoyActions/TransferItems.gd",
		"deposit":items_to_deposit,"collect":items_to_collect}

func _load(_data) -> void:
	items_to_deposit = _data["deposit"]
	items_to_collect = _data["collect"]
