extends ConvoyAction

var location:WorldObject
var button

func _init(_location = null) -> void:
	location = _location

func execute(convoy:WorldObject) -> void:
	# If the location is unoccupied, claim it then return
	#if location.faction == Global.UNCLAIMED_FACTION:
	#	location.faction = convoy.faction
	#	emit_signal("complete")
	#	return
		
	Global.world.launch_mission(location,convoy)
	return
	# Otherwise, prepare to launch mission
	# Need to wait for user to manually launch the mission, then wait for
	# the mission to end before emitting complete
	button = Button.new()
	button.anchors_preset = CORNER_TOP_RIGHT
	button.text = "Launch Mission"
	button.pressed.connect(Global.world.launch_mission)
	var ui = Global.world.get_node("CanvasLayer")
	ui.add_child(button)
	Global.time_controls.pause()

func mission_over() -> void:
	emit_signal("complete")

func save() -> Dictionary:
	return {
		"path": "res://World/WorldObjects/WO_Convoy/ConvoyActions/LaunchMission.gd",
		"location":var_to_str(location.world_position)
	}

func _load(_data) -> void:
	var pos = str_to_var(_data["location"])
	# HACK
	for i in Global.world.world_objects:
		if i.world_position == pos:
			location = i
			return
	pass
