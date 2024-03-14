extends Node2D
class_name Unit

var character:Character
var team:Team

var utilities:Array[Item]
var effects:Array[Effect]

func init(_character:Character) -> void:
	character = _character
	for utility_name in character.utilities:
		add_utility(utility_name)

func add_utility(_name:String) -> void:
	var item = Global.string2item(_name)
	utilities.append(item)
	
func new_turn():
	for effect in effects:
		effect.apply(self)

func add_effect(effect:Effect) -> void:
	effects.append(effect)
