extends PanelContainer

var world_map
var object:WorldObject
signal close

func init(_object:WorldObject):
	object = _object
	position = _object.world_position

func _on_close_pressed():
	emit_signal("close")
