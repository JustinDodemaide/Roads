extends Node2D
class_name MiscObject

var health:int = 1
var effects:Array[Effect]

func add_effect(effect:Effect) -> void:
	effects.append(effect)

func damage(amount:int) -> void:
	health -= amount
	if health <= 0:
		destroy()

func destroy() -> void:
	queue_free()
