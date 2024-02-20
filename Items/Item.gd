extends Resource
class_name Item

@export var name:String
@export var icon:Texture2D = load("res://Items/DefaultItemIcon.png")
@export var tooltip_text:String = "\n"

@export var cost:Dictionary
@export var build_time:int
#@export var execute_logic:Script
#
#var num_uses: int
#var available: bool
#var map
#var target_select: bool
#var no_selection: bool
#var cooldown: int
#var current_cooldown: int = 0 # current_cooldown should be 0 by default. to start the cooldown, set it equal to cooldown
#signal complete
