extends Control

@export var name_label:Label
@export var health_bar:ProgressBar

func init(unit:Unit) -> void:
	get_parent().remove_child(self)
	unit.add_child(self)
	position = Vector2(32,-32) # To the right of the unit
	name_label.text = unit.character.name
	health_bar.max_value = unit.max_health
	health_bar.value = unit.health
	visible = true
