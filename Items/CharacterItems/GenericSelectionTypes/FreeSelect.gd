extends SelectionType
# FreeSelect: The selection is position of the next mouse click

func start(_unit:Unit,_utility:Variant) -> void:
	Global.mission.position_left_clicked.connect(position_selected)

func position_selected(position:Vector2):
	var info:Dictionary = {"position":position}
	emit_signal("selection_made",info)
