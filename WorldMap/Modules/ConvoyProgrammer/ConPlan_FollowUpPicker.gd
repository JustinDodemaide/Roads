extends Node

var state_machine = null
var valid_followups:Dictionary = {}
var lines:Dictionary

func enter(_msg := {}) -> void:
	clear()
	determine_valid_followup_locations(_msg["location"])
	state_machine.world_map.map_object_clicked.connect(map_object_clicked)

func exit() -> void:
	state_machine.world_map.map_object_clicked.disconnect(map_object_clicked)

func map_object_clicked(map_object):
	var object = map_object.world_object
	if !valid_followups.has(object):
		return
	lines[object].default_color.a = 1
	lines[object].z_index = 1
	state_machine.transition_to("ConfirmFollowUp",{"location":object})

func determine_valid_followup_locations(from:WorldObject):
	valid_followups.clear()
	for i in Global.world.world_objects:
		if i == from:
			continue
		if i.faction != Global.player_faction_name:
			continue
		var path = Global.world.get_astar_path(from,i)

		valid_followups[i] = {"path": path}
		draw_path_line(i,path)

func draw_path_line(location,path):
	var line = Line2D.new()
	for pos in path:
		pos = Global.world.tilemap.map_to_local(Global.world.tilemap.local_to_map(pos))
		line.add_point(pos)
	randomize()
	var color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),0.5)
	line.default_color = color
	line.width = 5.0
	add_child(line)
	lines[location] = line

func clear():
	for i in lines:
		lines[i].queue_free()
	lines.clear()
