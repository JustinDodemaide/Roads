extends ConvoyAction

var location:WorldObject
var button

func _init(_location) -> void:
	location = _location

func execute(convoy:WorldObject) -> void:
	# If the location is unoccupied, claim it then return
	if location.faction == Global.UNCLAIMED_FACTION:
		location.faction = convoy.faction
		emit_signal("complete")
		return
	# Otherwise, prepare to launch mission
	# Need to wait for user to manually launch the mission, then wait for
	# the mission to end before emitting complete
	button = Button.new()
	button.anchors_preset = CORNER_TOP_RIGHT
	button.text = "Launch Mission"
	button.pressed.connect(launched)
	var ui = Global.world.get_node("CanvasLayer")
	ui.add_child(button)

func launched() -> void:
	button.queue_free()

func mission_over() -> void:
	emit_signal("complete")
