extends Item
class_name CharacterItem

@export var equippable:bool = false
@export var num_uses:int
@export var selection_type:GDScript = null
@export var action_point_cost:int = 1

@export var offensive_score:int = 0

signal complete

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	pass
