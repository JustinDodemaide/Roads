extends Control

func _ready():
	var label = $PanelContainer/Label
	var inventory = Global.player_faction.inventory
	for item_name:String in Global.player_faction.inventory:
		label.text += item_name + ": " + str(inventory[item_name]) + "\n"

func _on_button_pressed():
	queue_free()
