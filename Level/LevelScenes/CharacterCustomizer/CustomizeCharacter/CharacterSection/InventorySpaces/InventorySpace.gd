extends PanelContainer

var item:Item
var is_available:bool = true
signal clicked(item:Item)

func add_item(_item:Item):
	item = _item
	$Button.icon = item.icon
	
	# Things that need to be undone by remove_item:
	is_available = false
	$Button.visible = true

func remove_item():
	is_available = true
	$Button.visible = false

func _on_button_pressed():
	emit_signal("clicked",item)
	remove_item()
