extends Node

@export var column:VBoxContainer
@export var column_item:Control
@export var selection_panel:PanelContainer
var selected_item:Item

func _ready():
	# Based on research, make a list of items that are available
	var all_items:PackedStringArray = ["Waffle"]
	all_items.sort()
	for string in all_items:
		var new_column_item = column_item.duplicate()
		var path:String = "res://Items/" + string + "/" + string + ".tres"
		var item:Resource = load(path)
		new_column_item.init(item)
		column.add_child(new_column_item)

func _on_item_selected(item):
	selected_item = item
	selection_panel.init(item)

func _on_accept_pressed():
	for string in selection_panel.cost:
		Global.player_faction.remove_items(string,selection_panel.cost[string])
	Global.player_faction.add_items(selected_item.name,selection_panel.amount,true)

	selection_panel.visible = false
	selected_item = null

func _on_close_pressed():
	queue_free()
