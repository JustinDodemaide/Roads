extends Button

var item:Item
signal clicked(item:Item)

func init(_item:Item):
	item = _item
	icon = item.icon
	visible = true

func _on_pressed():
	emit_signal("clicked",item)
	visible = false
	item = null
