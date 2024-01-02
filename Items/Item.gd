extends RefCounted
class_name Item

func item_name() -> String:
	return "Item"

func world_texture() -> Texture2D:
	return null

func menu_icon() -> Texture2D:
	return load("res://Items/DefaultItemIcon.png")

func stack_max() -> int:
	return 64
