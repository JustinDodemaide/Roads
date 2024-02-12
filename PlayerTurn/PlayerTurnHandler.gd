extends RefCounted

var faction:Faction
var build_button:Button
var attack_button:Button
var reposition_button:Button
var action_container
var action_button_scene:PackedScene = preload("res://PlayerTurn/PlayerActionButton/PlayerActionButton.tscn")

func execute() -> void:
	var buttons = Global.world.ui.get_node("TurnProgressButtons").get_children()
	build_button = buttons[0]
	attack_button = buttons[1]
	reposition_button = buttons[2]
	action_container = Global.world.ui.get_node("Options")
	build_phase()

func build_phase():
	build_button.pressed.connect(attack_phase)
	build_button.disabled = false
	
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
	build_button.pressed.disconnect(attack_phase)
	build_button.disabled = true
	attack_button.pressed.connect(reposition_phase)
	attack_button.disabled = false

func reposition_phase() -> void:
	clear_buttons()
	attack_button.pressed.disconnect(reposition_phase)
	attack_button.disabled = true
	reposition_button.pressed.connect(turn_over)
	reposition_button.disabled = false

func turn_over() -> void:
	clear_buttons()
	reposition_button.pressed.disconnect(turn_over)
	reposition_button.disabled = true
	faction.emit_signal("turn_complete")

func clear_buttons() -> void:
	for i in action_container.get_children():
		i.queue_free()
