extends SelectionType

func has_valid_selections(_unit:Unit,_utility:Variant) -> Dictionary:
	if _unit.sensors.visible_enemies.is_empty():
		var msg = _unit.name + " can't see any enemies!"
		return {"has_valid_selection":false,"msg":msg}
	return {"has_valid_selection":true,"msg":null}

func start(_unit:Unit,_utility:Variant) -> void:
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
