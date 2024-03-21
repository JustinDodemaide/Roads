extends Node2D
class_name MiscObject

var effects:Array[Effect]

func _ready():
	pass

func add_effect(effect:Effect) -> void:
	effects.append(effect)

