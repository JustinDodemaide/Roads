extends Control

@export var inv_label:Label
@export var character:Label

func _ready():
	var inventory = Global.player_faction.inventory
	for item_name:String in inventory:
		inv_label.text += item_name + ": " + str(inventory[item_name]) + "\n"
	inventory = Global.player_faction.character_items
	for item_name:String in inventory:
		character.text += item_name + ": " + str(inventory[item_name]) + "\n"

func _on_button_pressed():
	Global.world.ui.get_node("Inventory").visible = true
	queue_free()
