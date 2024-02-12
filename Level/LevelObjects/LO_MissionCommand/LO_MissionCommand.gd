extends Node2D



func _on_button_pressed():
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module":"MissionPlanner"})
