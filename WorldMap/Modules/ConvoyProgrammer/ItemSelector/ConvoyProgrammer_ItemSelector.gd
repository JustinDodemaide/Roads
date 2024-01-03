extends ColorRect

@onready var deposit_available = $VBoxContainer/MarginContainer2/HBoxContainer/Deposit/HBoxContainer/Available/ScrollContainer/PUTBUTTONHERE
@onready var deposit_selected = $VBoxContainer/MarginContainer2/HBoxContainer/Deposit/HBoxContainer/Selected/ScrollContainer/PUTBUTTONHERE
@onready var collect_available = $VBoxContainer/MarginContainer2/HBoxContainer/Collect/HBoxContainer/Available/ScrollContainer/PUTBUTTONHERE
@onready var collect_selected = $VBoxContainer/MarginContainer2/HBoxContainer/Collect/HBoxContainer/Selected/ScrollContainer/PUTBUTTONHERE

func _init(items_available_at_stop:Dictionary,location):
	for items_available_at_stop:
		
	for i in location.storage:
		pass
