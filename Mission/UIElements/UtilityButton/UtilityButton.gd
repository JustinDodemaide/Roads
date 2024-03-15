extends Button

var utility:Item
signal utility_chosen(utility:Item)

func init(_utility:Item) -> void:
	utility = _utility
	text = utility.name
	icon = utility.icon
	tooltip_text = utility.tooltip_text
	if utility.num_uses == 0:
		disabled = true
		return
	if utility.num_uses > 0:
		text += " " + str(utility.num_uses)

func _on_pressed():
	emit_signal("utility_chosen",utility)
