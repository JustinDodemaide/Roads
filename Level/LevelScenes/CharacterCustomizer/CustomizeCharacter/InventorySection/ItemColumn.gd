extends VBoxContainer

@export var column_item:PackedScene = preload("res://Level/LevelScenes/CharacterCustomizer/CustomizeCharacter/InventorySection/ColumnItem/ColumnItem.tscn")
@export var root:Node

func init(items:Dictionary):
	for item_name in items:
		var item:Item = Global.string2item(item_name)
		var new_column_item = column_item.instantiate()
		new_column_item.init(item,items[item_name])
		new_column_item.item_chosen.connect(root._on_inventory_item_clicked)
		add_child(new_column_item)

func add_item(item:Item):
	for column_item in get_children():
		if column_item.item == item:
			column_item.add_one()
			return
	var new_column_item = column_item.instantiate()
	new_column_item.init(item,1)
	new_column_item.item_chosen.connect(root._on_inventory_item_clicked)
	add_child(new_column_item)
