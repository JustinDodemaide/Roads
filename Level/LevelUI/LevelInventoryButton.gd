extends Button

@export var number:int
signal inventory_slot_selected(n)


func _on_pressed():
	emit_signal("inventory_slot_selected",number)

func update(item_stack:ItemStack) -> void:
	tooltip_text = item_stack.item.item_name()
	icon = item_stack.item.menu_icon()
	if item_stack.quantity > 1:
		$Quantity.text = str(item_stack.quantity)
