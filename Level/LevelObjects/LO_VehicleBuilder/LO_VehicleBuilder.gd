extends LevelObject

var option_paths:PackedStringArray = []

func _name():
	return "Vehicle Builder"

func is_interaction_valid(_interactor) -> bool:
	return true

func interact(_interactor) -> void:
	var file_path:String = "user://" + str(StartGameParameters.save) + "ResearchedVehicles.save"
	var file = FileAccess.open(file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var script_path = file.get_line()
		var script = load(script_path).new()
		$OptionButton.add_item(script._name())
		option_paths.append(script_path)
	$OptionButton.visible = true

func _on_option_button_item_selected(index):
	var vehicle = load(option_paths[index]).new()
	Global.player_location.vehicles.append(vehicle)
