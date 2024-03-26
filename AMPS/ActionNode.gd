extends RefCounted
class_name ActionNode

var parent:ActionNode
var action:Action
var score:float

func _init(_parent, _action, _score):
	parent = _parent
	action = _action
	score = _score
