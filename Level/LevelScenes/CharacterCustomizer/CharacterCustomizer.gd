extends Node

@export var item_list:VBoxContainer
@export var utility_container:HBoxContainer

var character:Character
var level_object

func init(_character:Character,_level_object):
	character = _character
	level_object = _level_object
	utility_container.init(character)
	
	var player_items = Global.player_faction.character_items
	for item_name in player_items:
		var item_list_item = item_list.get_node("Item").duplicate()
		var item:Item = Global.string2item(item_name)
		item_list_item.init(item,player_items[item_name])
		item_list.add_child(item_list_item)

func _on_inventory_item_clicked(item:Item):
	if item.equippable:
		pass
	else:
		utility_container.add_item(item)

func _on_item_deselected(item):
	# Re-add the item to faction.character_item list
	for item_list_item in item_list.get_children(): # Really gotta work on these names
		pass

func _on_back_pressed():
	var menu = load("res://Level/LevelScenes/CharacterCustomizer/CharacterChooser/CharacterChooser.tscn").instantiate()
	menu.level_object = self
	level_object.add_child(menu)
	queue_free()

func _on_confirm_pressed():
# Don't remove anything from faction.character_items
# and don't add anything to character
# until the confirm button is pressed
	pass # Replace with function body.
