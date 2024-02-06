extends RefCounted
class_name PlayerAction

func text() -> String:
	return "Module"

func description() -> String:
	return "This is a module"

func icon() -> Texture2D:
	return load("res://icon.svg")
