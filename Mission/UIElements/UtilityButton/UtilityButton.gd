extends Button

var utility:Item
signal utility_chosen(utility:Item)

func init(_utility:Item) -> void:
	utility = _utility
	text = utility.name
	icon = utility.icon
	tooltip_text = utility.tooltip_text

func _on_pressed():
	emit_signal("utility_chosen",utility)
