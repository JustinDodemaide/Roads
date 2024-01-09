extends Control

# Menu for the creation of LevelObjects

var option_paths:PackedStringArray = []
signal building_selected(path:String)

func _ready() -> void:
	var file_path:String = "user://" + str(StartGameParameters.save) + "ResearchedFacilities.save"
	var file = FileAccess.open(file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var script_path = file.get_line()
		var script = load(script_path).new()
		$OptionButton.add_item(script._name())
		var scene_path = script_path.replace(".gd",".tscn")
		# HACK? Not sure how inefficient this is compared to storing both
		# paths seperately
		option_paths.append(scene_path)

func _on_option_button_item_selected(index):
	emit_signal("building_selected",load(option_paths[index]).instantiate())
	queue_free()
