extends RefCounted
class_name Item

func item_name() -> String:
	return "Item"

func path() -> String:
	var underscored = item_name().replace(" ", "_")
	return "res://Items/"+ underscored +"/Item_" + underscored + ".gd"

func world_texture() -> Texture2D:
	return null

func menu_icon() -> Texture2D:
	return load("res://Items/DefaultItemIcon.png")

func size() -> int:
	return 0

func save() -> Dictionary:
	return {"path":path()}
