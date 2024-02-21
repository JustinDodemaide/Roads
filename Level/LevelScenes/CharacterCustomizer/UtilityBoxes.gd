extends HBoxContainer

@export var empty_space:PanelContainer

func init(character:Character):
	for i in character.utility_slots:
		var space = empty_space.duplicate()
		space.visible = true
		add_child(space)
	
	var spaces = get_children()
	for index in character.utilities.size():
		var item:Item = Global.string2item(character.utilities[index])
		spaces[index].get_node("Button").init(item)

func add_item(item:Item):
	# Add the item to the first empty slot
	for space in get_children():
		var button = space.get_node("Button")
		if button.visible == false: # The slot is empty
			button.init(item)
			return
