extends Node
class_name Agent

signal plan_updated(queue)

@export var map_key:String
@onready var action_map

var character

var goals:Dictionary = {
	"has_enemy":false,
	"chill":true
}

var current_goal
var plan_queue:Array[Action] = []
var current_action:Action


func act():
	action_map = AIActionMaps.action_maps[map_key]
	# Finish the current action
	if current_action != null:
		if current_action.is_running:
			return
	# If the goal priority has changed, the character needs to stop
	# and switch to the highest priority goal
	var priority_goal:Dictionary = highest_priority_goal()
	if priority_goal != current_goal:
		current_goal = highest_priority_goal()
		plan_queue = []
		
	if priority_goal.is_empty():
		return

	if plan_queue.is_empty():
		make_plan_queue()
	if not plan_queue.is_empty():
		emit_signal("plan_updated", plan_queue)
		# there are actions that need to be performed
		current_action = plan_queue.pop_front()
		if current_action.is_valid(character):
			current_action.perform(character)
		else:
			current_action = null
			# If we can't complete a step in the sequence, get rid of the whole
			# plan before it breaks something
			plan_queue = []
			
func highest_priority_goal()->Dictionary:
	for key in goals:
		if goals[key] != character.states[key]:
			return {key:goals[key]}
	return {}

func make_plan_queue():
	var plan_leaves:Array[ActionNode] = []
	plan(ActionNode.new(null, Action.new(), 0), current_goal, plan_leaves)
	if plan_leaves.is_empty():
		return
	# The score of each leaf node contains the score of the entire path.
	var best_leaf:ActionNode = plan_leaves.front()
	var best_score:float = plan_leaves.front().score
	for leaf in plan_leaves:
		# This is obviously going to waste one cycle bc the first has already been evaluated
		if leaf.score > best_score:
			best_leaf = leaf
			best_score = leaf.score
	# Traverse back up the node to make the plan queue.
	var current_node:ActionNode = best_leaf
	while current_node != null:
		plan_queue.push_back(current_node.action)
		current_node = current_node.parent
	plan_queue.pop_back() # The last step is always going to be the dummy node, so just get rid of it
	pass

# Returns false if the planning failed, true if successful.
func plan(current_node:ActionNode, precondition_to_satisfy:Dictionary, leaves:Array[ActionNode])->void:
	# If the precondition is already satisfied, move on
	if condition_already_met(precondition_to_satisfy):
		leaves.append(current_node)
		return
	
	if not action_map.has(precondition_to_satisfy):
		return
	var actions_that_satisfy_precondition = action_map[precondition_to_satisfy]
	if actions_that_satisfy_precondition.is_empty():
		return
	for action in actions_that_satisfy_precondition:
		var action_instance:Action = load("res://Actions/" + action + ".gd").new()
		if not action_instance.is_valid(character):
			continue
		var new_node = ActionNode.new(current_node, action_instance, current_node.score + action_instance.get_score())
		var new_preconditions:Dictionary = action_instance.get_preconditions()
		if new_preconditions.is_empty():
			# If the action doesn't have any preconditions, we hit a leaf
			leaves.append(new_node)
			continue
		for key in new_preconditions:
			var new_precondition_to_satisfy:Dictionary = {key: new_preconditions[key]}
			plan(new_node, new_precondition_to_satisfy, leaves)

func condition_already_met(precondition:Dictionary) -> bool:
	var key = precondition.keys().front()
	if precondition[key] == character.states[key]:
		return true
	return false
