extends SelectionType

var unit

func get_validity_info(_unit:Unit,_utility:Variant) -> Dictionary:
	if _unit.sensors.visible_enemies.is_empty():
		var msg = _unit.name + " can't see any enemies!"
		return {"has_valid_selection":false,"msg":msg}
	return {"has_valid_selection":true,"msg":null}

func start(_unit:Unit,_utility:Variant) -> void:
	unit = _unit
	Global.mission.ui.clear_utilities() # HACK
	var target_scene:PackedScene = load("res://Mission/UIElements/TargetButton/TargetButton.tscn")
	for enemy in _unit.sensors.visible_enemies:
		var button = target_scene.instantiate()
		button.init(enemy,get_percent(enemy))
		button.target_selected.connect(target_selected)
		Global.mission.ui.clear_utilities()
		Global.mission.ui.add_target(button)

func get_percent(target:Unit) -> int:
	# Get angle
	# Get direction based on angle
	# Change percentage based on target cover
	target.sensors.cover.update() # Not sure how necessary this is bc I haven't
	# figured out when the sensors are going to be updated
	var angle = rad_to_deg(unit.position.angle_to_point(target.position))
	var direction = Global.deg_to_cardinal_string(angle)
	if direction == "North" or direction == "Northwest" or direction == "Northeast":
		if target.sensors.cover.north:
			return 50
	if direction == "East" or direction == "Northeast" or direction == "Southeast":
		if target.sensors.cover.east:
			return 50
	if direction == "South" or direction == "Southeast" or direction == "Southwest":
		if target.sensors.cover.south:
			return 50
	if direction == "West" or direction == "Northwest" or direction == "Southwest":
		if target.sensors.cover.west:
			return 50
	return 100

func target_selected(target:Unit,percent:int):
	Global.mission.ui.clear_utilities() # HACK
	var info:Dictionary = {"target":target,"percent":percent}
	emit_signal("selection_made",info)
