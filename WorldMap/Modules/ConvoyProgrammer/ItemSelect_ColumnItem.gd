extends PanelContainer

@onready var text_edit = $MarginContainer/HBoxContainer/TextEdit

var item:Item
var item_string:String
var total
var selected_amount = 0

func init(_item:String,amount):
	item_string = _item
	item = load("res://Items/" + _item + "/Item_" + _item + ".gd").new()
	$MarginContainer/HBoxContainer/Image.texture = item.menu_icon()
	$MarginContainer/HBoxContainer/Name.text = item.item_name()
	total = amount
	$MarginContainer/HBoxContainer/Total.text = str(amount)

func _on_text_edit_text_changed():
	if not text_edit.text.is_valid_int():
		text_edit.text = ""
		selected_amount = 0
		return
	var amount = text_edit.text.to_int()
	if amount > total:
		amount = total
		text_edit.text = str(amount)
	if amount < 0:
		amount = 0
		text_edit.text = str(amount)
	selected_amount = amount
