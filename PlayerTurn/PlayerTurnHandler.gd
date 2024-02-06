extends RefCounted

var faction:Faction
var progress_button
var action_container

var action_button_scene:PackedScene = preload("res://PlayerTurn/PlayerActionButton/PlayerActionButton.tscn")

func execute() -> void:
	progress_button = Global.world.ui.get_node("TurnProgression")
	action_container = Global.world.ui.get_node("Options")

	progress_button.visible = true
	# Build phase
	progress_button.text = "Attack"
	progress_button.pressed.connect(attack_phase)
	
	# Research, build equipment, build facility, upgrade
	var modules = [
		load("res://PlayerTurn/Modules/PlayerAction.gd").new()
	]
	for mod in modules:
		var button = action_button_scene.instantiate()
		button.init(mod)
		action_container.add_child(button)

func attack_phase() -> void:
	clear_buttons()
	progress_button.pressed.disconnect(attack_phase)
	progress_button.text = "Reposition"
	progress_button.pressed.connect(reposition_phase)

func reposition_phase() -> void:
	clear_buttons()
	progress_button.pressed.disconnect(reposition_phase)
	progress_button.text = "End turn"
	progress_button.pressed.connect(turn_over)

func turn_over() -> void:
	clear_buttons()
	progress_button.pressed.disconnect(turn_over)
	progress_button.visible = false
	faction.emit_signal("turn_complete")

func clear_buttons() -> void:
	for i in action_container.get_children():
		i.queue_free()
