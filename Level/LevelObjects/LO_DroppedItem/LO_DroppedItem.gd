extends LevelObject

var item_stack:ItemStack

func init(stack:ItemStack):
	item_stack = stack
	$Sprite2D.texture = item_stack.item.world_texture()

func _name() -> String:
	return item_stack.item_name()

func is_interaction_valid(_interactor) -> bool:
	print(_name(), " clicked on")
	if _interactor.can_carry_item(item_stack):
		return true
	return false

func interact(_interactor) -> void:
	_interactor.carry_item(item_stack)
	queue_free()

func save_additional_fields(save_dict:Dictionary) -> void: # Modifies the dictionary reference
	# save item stack
	pass

func additional_load_fields(_data:Dictionary) -> void:
	pass

func dropped_item():
	pass
