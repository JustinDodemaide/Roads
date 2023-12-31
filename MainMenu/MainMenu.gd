extends Node

const MAX_SAVES:int = 5
var num_saves = 0

func _ready():
	for i in MAX_SAVES:
		var file_path:String = "user://" + "Save" + str(i) + ".save"
		if FileAccess.file_exists(file_path):
			num_saves += 1
	StartGameParameters.num_saves = num_saves
	$Label.text = "num_saves: " + str(num_saves)
	if num_saves != 0:
		$HBoxContainer/Button.disabled = true
	else:
		$HBoxContainer/Button2.disabled = true

func _on_button_2_pressed():
	StartGameParameters.save = 1
	get_tree().change_scene_to_file("res://World/World.tscn")
	#"...the formerly current scene, already removed from the tree, will be
	# deleted (freed from memory) and then the new scene will be instantiated
	# and added to the tree"

func _on_button_pressed():
	StartGameParameters.save = 0
	get_tree().change_scene_to_file("res://World/World.tscn")
