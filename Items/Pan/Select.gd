extends SelectionType

func start(_unit) -> void:
	Global.mission.ui.clear_utilities() # HACK
	var target_scene:PackedScene = load("res://Mission/UIElements/TargetButton/TargetButton.tscn")
	for enemy in _unit.sensors.visible_enemies:
		var button = target_scene.instantiate()
		button.init(enemy,get_percent(enemy))
		button.target_selected.connect(target_selected)
		Global.mission.ui.clear_utilities()
		Global.mission.ui.add_target(button)

func get_percent(target:Unit) -> int:
	return 100

func target_selected(target:Unit,percent:int):
	Global.mission.ui.clear_utilities() # HACK
	var info:Dictionary = {"target":target,"percent":percent}
	emit_signal("selection_made",info)
