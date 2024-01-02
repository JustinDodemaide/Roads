extends Node

var state_machine = null
var valid_followups:Dictionary = {}
var lines:Dictionary


# Instead of tracking the fuel used every stop, add up one flat cost that they
# pay per circuit (or when they launch a convoy) that doesn't account for extra
# travel (like changing destination)



func enter(_msg := {}) -> void:
	clear()
	determine_valid_followup_locations(_msg["location"])
	state_machine.world_map.map_object_clicked.connect(map_object_clicked)

func exit() -> void:
	state_machine.world_map.map_object_clicked.disconnect(map_object_clicked)

# Change it to: left click brings up stats, right click chooses location
func map_object_clicked(map_object):
	var object = map_object.world_object
	if !valid_followups.has(object):
		return
	lines[object].default_color.a = 1
	lines[object].z_index = 1
	
	#var con:Array[ItemStack] = [ItemStack.new(load("res://Items/Fuel/Item_Fuel.gd").new(),fuel_required[object])]
	state_machine.transition_to("ConfirmFollowUp",{"location":object,"fuel_cost":fuel_costs[object]})

var fuel_costs:Dictionary
func determine_valid_followup_locations(from:WorldObject):
	valid_followups.clear()
	for location in Global.world.world_objects:
		if location == from:
			continue
		if location.faction != Global.player_faction_name:
			continue
		var path = Global.world.get_astar_path(from,location)
		fuel_costs[location] = path.size() * state_machine.total_fuel_consumption
		#fuel_required[location] = path.size() * state_machine.vehicle_stats["total_fuel_consumption"]
		#if fuel_required[location] > fuel_available_by_stop(location):
			#continue
			
		valid_followups[location] = {"path": path}
		draw_path_line(location,path)

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

#func fuel_available_by_stop(location) -> int:
	#var items_before_stop = state_machine.convoy_items_before_stop(location)
	#var available_fuel = 0
	#for i in items_before_stop:
		#if i.item_name().contains("Fuel"):
			#available_fuel += i.quantity
	#return available_fuel
