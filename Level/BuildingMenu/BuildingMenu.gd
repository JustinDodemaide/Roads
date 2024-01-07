extends Control

# The player can select any building from any location, but they might not be able
# to build the selected building (the validity of the building is checked after 
# being selected

enum {TIER1_HARVESTER}

signal building_selected(building:LevelObject)

func _on_option_button_item_selected(index):
	var building:PackedScene
	match index:
		TIER1_HARVESTER:
			building = load("res://Level/LevelObjects/LO_Tier0Harvester/LO_Tier0Harvester.tscn")
	emit_signal("building_selected",building.instantiate())
	queue_free()
