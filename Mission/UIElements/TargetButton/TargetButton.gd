extends PanelContainer

var target:Unit
var percent:int
@export var name_label:Label
@export var percent_label:Label

signal target_selected(target:Unit,percent)

func init(_target:Unit,_percent:int) -> void:
	target = _target
	percent = _percent
	name_label.text = target.character.name
	percent_label.text = str(percent)

func _on_button_pressed():
	emit_signal("target_selected",target)

func _on_button_mouse_entered():
	Global.mission.camera.move_to(target.position,percent)
