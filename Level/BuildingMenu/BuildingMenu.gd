extends Control

# All buildables are displayed, but only the valid ones are selectable

var option_scene_paths:PackedStringArray = []
signal building_selected(building:LevelObject)

func init(category:String) -> void:
	var file_path:String = "user://" + str(StartGameParameters.save) + "Researched" + category + ".save"
	var file = FileAccess.open(file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var data:Dictionary = JSON.parse_string(line)
		var script_path = data["path"]
		var script = load(data["path"]).new()
		var scene_path = script_path.replace(".gd",".tscn")
		# HACK? Not sure how inefficient this is compared to storing both
		# paths seperately
		option_scene_paths.append(scene_path)

func new_option(script):
	$OptionButton.add_item(script._name())

func _on_option_button_item_selected(index):
	var building = load(option_scene_paths[index]).instantiate()
	emit_signal("building_selected",building)
	queue_free()
