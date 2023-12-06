class_name ItemStack

var item:Item
var quantity:int

func _init(_item:Item, _quantity:int = 1):
	item = _item
	quantity = _quantity

func item_name() -> String:
	return item.item_name()
