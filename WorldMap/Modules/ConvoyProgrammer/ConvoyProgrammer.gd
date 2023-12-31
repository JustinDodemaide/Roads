extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)
@onready var state = $VehiclePicker

var world_map
@onready var current_location = Global.level.world_object
var vehicles
var stops:Array = []

# UI element refs
@onready var vehicle_chooser = $UI/ConvoyProgammerVehicleChooser
@onready var complete_circuit_button = $UI/HBoxContainer/CompleteCircuit
@onready var confirm_program_button = $UI/HBoxContainer/Confirm

func _ready() -> void:
	for child in get_children():
		if child.name == "UI":
			continue
		child.state_machine = self
	state.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)

func add_stop(loc:WorldObject):
	stops.append(loc)
	update_ui()

func update_ui():
	if stops.back() == current_location:
		confirm_program_button.disabled = false
		complete_circuit_button.disabled = true
	else:
		confirm_program_button.disabled = true
		complete_circuit_button.disabled = false
	
	var stop_list = $UI/Stops
	stop_list.text = "Stops: "
	for i in stops:
		stop_list.text += i.name() + " "
	
	#make_flag()

func _on_complete_circuit_pressed():
	add_stop(current_location)
	transition_to("FollowUpPicker",{"location":current_location})

func _on_confirm_pressed():
	queue_free()

@onready var flag = $ConfirmFollowUp/Button
var flags:Dictionary
func make_flag():
	var location = stops.back()
	var dup = flag.duplicate()
	dup.text = str(stops.size())
	dup.visible = true
	if flags.has(location):
		dup.modulate = flags[location].get_children().front().modulate
		flags[location].add_child(dup)
	else:
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.position = location.world_position
		hbox.anchors_preset = Control.PRESET_CENTER
		dup.modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
		hbox.add_child(dup)
		add_child(hbox)
		flags[location] = hbox
