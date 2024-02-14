extends Node2D

# For moving characters between player owned territories

func _on_button_pressed():
	var info = {"mission":false}
	# It didn't make sense to split 'mission planner' and 'character mover'
	# into different scenes, so I needed a way to know which was being use
	#  in the module
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module":"CharacterMover","module_msg":info})
