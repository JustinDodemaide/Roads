extends PanelContainer

var utility_spaces:HBoxContainer
@export var icon:TextureRect
@export var label:Label

var item:Item
var amount:int

func init(_item:Item,_amount:int):
	item = _item
	amount = _amount
	icon.texture = item.icon
	label.text = item.name + ", " + str(amount)
	visible = true

func add_one():
	amount += 1
	label.text = item.name + ", " + str(amount)

func remove_one():
	amount -= 1
	label.text = item.name + ", " + str(amount)
	if amount <= 0:
		queue_free()

func _on_button_pressed():
	var successfully_added = utility_spaces.add_item(item)
	if successfully_added:
		remove_one()
