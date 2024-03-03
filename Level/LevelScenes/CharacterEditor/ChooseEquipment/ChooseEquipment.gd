extends Node

@export var item_column:VBoxContainer
@export var utility_container:HBoxContainer

var state_machine

func enter(_msg={}):
	utility_container.init(state_machine.character)
	var player_items = Global.player_faction.character_items
	item_column.init(player_items)

func character_item_deselected(item:Item):
	# Re-add the item to faction.state_machine.character_item list
	item_column.add_item(item)

func _on_back_pressed():
	state_machine.transition_to("EditorOptions")

func _on_confirm_pressed():
# Don't remove anything from faction.state_machine.character_items
# and don't add anything to state_machine.character
# until the confirm button is pressed
	var utility_items:Array[String] = utility_container.get_items()
	# Add them to state_machine.character
	state_machine.character.set_utilities(utility_items)
	for item:String in utility_container.get_items():
		# Remove them from player inventory
		Global.player_faction.remove_items(item,1,true)
	state_machine.transition_to("EditorOptions")

func exit():
	pass
