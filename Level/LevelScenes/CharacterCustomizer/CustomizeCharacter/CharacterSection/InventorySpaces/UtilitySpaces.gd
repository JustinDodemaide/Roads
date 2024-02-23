extends HBoxContainer

@export var root:Node
@onready var empty_space:PackedScene = preload("res://Level/LevelScenes/CharacterCustomizer/CustomizeCharacter/CharacterSection/InventorySpaces/InventorySpace.tscn")

func init(character:Character):
	for i in character.utility_slots:
		var space = empty_space.instantiate()
		space.clicked.connect(root._on_character_item_deselected)
		add_child(space)
	
	var empty_spaces = get_children()
	for index in character.utilities.size():
		var item:Item = Global.string2item(character.utilities[index])
		empty_spaces[index].add_item(item)

func add_item(item:Item):
	# Add the item to the first empty slot
	for space in get_children():
		if space.is_available:
			space.add_item(item)
			return
