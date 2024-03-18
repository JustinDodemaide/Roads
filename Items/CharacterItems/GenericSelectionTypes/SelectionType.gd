extends Resource
class_name SelectionType

# In a mission, after choosing the item as a utility, some follow-up input
# from the player will (most likely) be expected. Ex Choosing a gun requires the
# player to select a target to use it on, or choosing a grenade requires the
# player to select where it gets thrown
# Because the follow-ups are different across the utilities, its necessary to
# define their behavior seperately, then give each utility a reference to the
# script defining the behavior
# Unless the utility doesn't require a follow-up selection, in which case it
# remains null

signal selection_made(selection:Dictionary)

func start(_unit:Unit,_utility:Variant) -> void:
	pass

func clear() -> void:
	pass
