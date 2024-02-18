extends Node


func init(wo:WorldObject):
	var resource_column_item = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Resources/PanelContainer/ResourceColumn/Item
	var resource_column = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Resources/PanelContainer/ResourceColumn
	for resource in wo.resources:
		var item = resource_column_item.duplicate()
		item.init(resource)
		resource_column.add_child(item)

func _on_close_pressed():
	queue_free()
