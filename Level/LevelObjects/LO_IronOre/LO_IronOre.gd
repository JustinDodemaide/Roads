extends LevelObject

var health:int = 5

func _name():
	return "Iron Ore"

func is_interaction_valid(_interactor) -> bool:
	print(_name(), " clicked on")
	if _interactor.held_item == null:
		return false
	if _interactor.held_item.item.item_name() != "Pickaxe":
		return false
	return true

func interact(_interactor) -> void:
	print(_name(), " interacted with")
	
	var item = load("res://Items/IronOre/Item_IronOre.gd").new()
	var amount = randi_range(1,2)
	var stack = ItemStack.new(item, amount)
	var pos_x = position.x + randi_range(-64,64)
	var pos_y = position.y + randi_range(-64,64)
	Global.level.make_dropped_item(stack,Vector2(pos_x,pos_y))
	
	health -= 1
	if health <= 0:
		queue_free()
