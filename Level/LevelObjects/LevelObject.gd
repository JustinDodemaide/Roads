extends Node
class_name LevelObject

func _name() -> String:
	return "Level Object"

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	return false

func interact(interactor) -> void:
	pass
