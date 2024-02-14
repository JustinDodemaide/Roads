extends Node

# ChooseDestination

var state_machine = null

var valid_followups:Dictionary
var dest
var fuel_costs:Dictionary
var lines:Dictionary

func enter(_msg := {}) -> void:
	$UIElements.visible = true
	determine_valid_followup_locations(Global.current_location)
	state_machine.world_map.map_object_clicked.connect(map_object_clicked)

func exit() -> void:
	clear()
	state_machine.world_map.map_object_clicked.disconnect(map_object_clicked)
	$UIElements.visible = false

func determine_valid_followup_locations(from:WorldObject):
	valid_followups.clear()
	var attacking = state_machine.msg["mission"]
	for location in Global.world.world_objects:
		if location == Global.current_location:
			continue
		if attacking:
			if location.faction != null:
				if location.faction.is_player:
					continue
		if not attacking:
			if location.faction == null:
				continue
			if not location.faction.is_player:
				continue
		var path = Global.world.get_astar_path(from,location)
		fuel_costs[location] = path.size()
		valid_followups[location] = {"path": path}
		draw_path_line(location,path)
	if valid_followups.is_empty():
		return

# Change it to: left click brings up stats, right click chooses location
func map_object_clicked(map_object):
	var object = map_object.world_object
	if not valid_followups.has(object):
		return
	$UIElements/VBoxContainer/ConfirmButton.disabled = false
	lines[object].default_color.a = 1
	lines[object].z_index = 1
	$UIElements/VBoxContainer/Upfront.text = "Upfront fuel cost: " + str(fuel_costs[object])
	state_machine.destination = object
	state_machine.upfront_cost = fuel_costs[object]

func _on_confirm_button_pressed():
	state_machine.transition_to("ReviewAndConfirm")

func draw_path_line(location,path):
	var line = Line2D.new()
	for pos in path:
		pos = Global.world.tilemap.map_to_local(Global.world.tilemap.local_to_map(pos))
		line.add_point(pos)
	randomize()
	var color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),0.35)
	line.default_color = color
	line.width = 5.0
	add_child(line)
	lines[location] = line

func clear():
	for i in lines:
		lines[i].queue_free()
	lines.clear()
