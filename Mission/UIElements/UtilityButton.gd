extends Control

var utility:Item
signal utility_chosen(utility:Item)

func init(_utility:Item) -> void:
	utility = _utility
	$Button.text = utility.name
	$Button.icon = utility.icon
	$Button.tooltip_text = utility.tooltip_text

func _on_button_pressed():
	emit_signal("utility_chosen",utility)
