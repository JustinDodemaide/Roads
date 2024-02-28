extends Node

@export var item_column:VBoxContainer
@export var utility_container:HBoxContainer

var character:Character
var level_object

func init(_character:Character,_level_object):
	character = _character
	level_object = _level_object
	utility_container.init(character)
	
	var player_items = Global.player_faction.character_items
	item_column.init(player_items)

func _on_inventory_item_clicked(item:Item):
	if item.equippable:
		pass
	else:
		utility_container.add_item(item)

func _on_character_item_deselected(item:Item):
	# Re-add the item to faction.character_item list
	item_column.add_item(item)

func _on_back_pressed():
	var menu = load("res://Level/LevelScenes/CharacterCustomizer/CharacterChooser/CharacterChooser.tscn").instantiate()
	menu.level_object = self
	level_object.add_child(menu)
	queue_free()

func _on_confirm_pressed():
# Don't remove anything from faction.character_items
# and don't add anything to character
# until the confirm button is pressed
	var utility_items:Array[String] = utility_container.get_items()
	# Add them to character
	character.add_utilities(utility_items)
	for item:String in utility_container.get_items():
		# Remove them from player inventory
		Global.player_faction.remove_items(item,1,true)
	queue_free()
