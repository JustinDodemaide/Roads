extends RefCounted
class_name Unit

var character:Character

var effects:Array[Effect]

func init(_character:Character) -> void:
	character = _character

func new_turn():
	for effect in effects:
		effect.apply(self)

func add_effect(effect:Effect) -> void:
	effects.append(effect)
