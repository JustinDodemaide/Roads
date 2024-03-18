extends Button

var utility:Variant
signal utility_chosen(utility:Variant)

func init(_utility:Variant) -> void:
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
