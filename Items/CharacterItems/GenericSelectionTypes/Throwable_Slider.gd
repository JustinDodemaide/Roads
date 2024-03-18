extends SelectionType

var slider
var direction_line
var position:Vector2
var position_chosen:bool = false # TODO

func start(_unit:Unit,_utility:Variant) -> void:
	slider = load("res://Mission/UIElements/ThrowableElements/ThrowableSlider.tscn").instantiate()
	slider.init(_utility)
	slider.force_chosen.connect(force_chosen)
	Global.mission.ui.add_child(slider)
	Global.mission.position_left_clicked.connect(position_selected)

func position_selected(_position:Vector2):
	if position_chosen: # TODO obviously the player needs a way to re-choose
		return
	position = _position
	position_chosen = true

func force_chosen(force:int) -> void:
	slider.queue_free()
	var info:Dictionary = {"position":position,"force":force}
	emit_signal("selection_made",info)

func clear():
	if slider != null:
		slider.queue_free()
