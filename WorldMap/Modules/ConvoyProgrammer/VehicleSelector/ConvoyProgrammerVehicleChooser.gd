extends Control

var available_column
var selected_column
signal characters_chosen(characters,stats)

func init(location):
	available_column = $VBoxContainer/HBoxContainer/A/ScrollContainer/AvailableColumn
	selected_column = $VBoxContainer/HBoxContainer/S/ScrollContainer/SelectedColumn
	for character in location.characters:
		var button = load("res://WorldMap/Modules/CharacterMover/CharacterSelector/CharacterSelectorButton.tscn").instantiate()
		button.init(character)
		button.pressed.connect(button_pressed)
		available_column.add_child(button)
	update()

func button_pressed(button):
	if button.available:
		button.available = false
		available_column.remove_child(button)
		selected_column.add_child(button)
	else:
		button.available = true
		selected_column.remove_child(button)
		available_column.add_child(button)
	update()

func update():
	if selected_column.get_children().is_empty():
		$VBoxContainer/ConfirmButton.disabled = true
	else:
		$VBoxContainer/ConfirmButton.disabled = false

	$ColorRect.custom_minimum_size = $VBoxContainer.size

func _on_confirm_button_pressed():
	var characters:Array[Character] = []
	for button in selected_column.get_children():
		characters.append(button.character)
	var stats = {}
	emit_signal("characters_chosen",characters,stats)
	queue_free()
