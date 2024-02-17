extends LevelObject

# For launching missions against non-player owned territories

func _on_button_pressed():
	var info = {"mission":true}
	# It didn't make sense to split 'mission planner' and 'character mover'
	# into different scenes, so I needed a way to know which was being use
	#  in the module
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module":"CharacterMover","module_msg":info})
