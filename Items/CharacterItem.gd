extends Item

@export var equippable:bool = false
@export var num_uses:int
@export var selection_type:Resource = null
@export var execution_behavior:Resource = null

@export var offensive_score:int = 0

# The waffle will be thrown, fire green fire bullets in a circle, then explode in purple flames

# Action based approach to executions?
# Throw, 
func execute(actor:Unit,_selection_info:Dictionary) -> void:
	execution_behavior.execute(self,actor,_selection_info)
