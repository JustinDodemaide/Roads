extends Item
class_name CharacterItem

@export var equippable:bool = false
@export var num_uses:int
@export var selection_type:GDScript = null
@export var action_point_cost:int = 1

@export var offensive_score:int = 0

@export var associated_action:String

signal complete

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	pass

func is_valid(_actor:Unit) -> bool:
	if _actor.action_points < action_point_cost:
		return false
	
	var selection_script = selection_type.new()
	var info = selection_script.get_validity_info(_actor,self)
	if info["has_valid_selection"] == false:
		# display info["msg"]
		return false
		
	return true
