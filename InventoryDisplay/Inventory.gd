extends Control

@export var label:Label

func _ready():
	var inventory = Global.player_faction.inventory
	for item_name:String in Global.player_faction.inventory:
		label.text += item_name + ": " + str(inventory[item_name]) + "\n"

func _on_button_pressed():
	Global.world.ui.get_node("Inventory").visible = true
	queue_free()
