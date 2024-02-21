extends PanelContainer

@export var icon:TextureRect
@export var label:Label

var item:Item
signal item_chosen(item:Item)

func init(_item:Item,amount:int):
	item = _item
	icon.texture = item.icon
	label.text = item.name + ", " + str(amount)
	visible = true

func add_one():
	pass

func remove_one():
	pass

func _on_button_pressed():
	emit_signal("item_chosen",item)
