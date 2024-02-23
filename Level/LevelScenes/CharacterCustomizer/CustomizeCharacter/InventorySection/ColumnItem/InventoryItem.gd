extends PanelContainer

@export var icon:TextureRect
@export var label:Label

var item:Item
var amount:int
signal item_chosen(item:Item)

func init(_item:Item,_amount:int):
	item = _item
	amount = _amount
	icon.texture = item.icon
	label.text = item.name + ", " + str(amount)
	visible = true

func add_one():
	amount += 1
	label.text = item.name + ", " + str(amount)

func _on_button_pressed():
	amount -= 1
	label.text = item.name + ", " + str(amount)
	emit_signal("item_chosen",item)
	if amount <= 0:
		queue_free()
