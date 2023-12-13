extends CharacterBody2D
class_name PlayerCharacter

@export var speed:int = 325

var inventory:Array[ItemStack] = [null,null,null,null,null]
var held_item:ItemStack

func _ready():
	for i in Global.level.get_node("UI/Inventory").get_children():
		i.inventory_slot_selected.connect(inventory_slot_selected)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('D'):
		$AnimatedSprite2D.flip_h = false
		velocity.x += 1
	if Input.is_action_pressed('A'):
		$AnimatedSprite2D.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed('S'):
		velocity.y += 1
	if Input.is_action_pressed('W'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
		pass
	else:
		move_and_slide()
		$AnimatedSprite2D.play("move")

func _process(_delta):
	if held_item == null:
		$HeldItemLabel.text = ""
	else:
		$HeldItemLabel.text = held_item.item.item_name()

func _input(_event):
	pass

func add_item(item_stack:ItemStack) -> void:
	inventory.append(item_stack)

func inventory_slot_selected(number:int) -> void:
	print("slot ", number, " selected")
	held_item = inventory[number]
	if held_item == null:
		$HeldItem.texture = null
	else:
		$HeldItem.texture = held_item.item.world_texture()

func can_carry_item(_item:ItemStack) -> bool:
	var full = true
	for i in inventory:
		if i == null:
			full = false
			break
	if full:
		return false
	return true

func carry_item(item:ItemStack) -> void:
	if not can_carry_item(item):
		return
	for slot in inventory.size():
		var added:bool = false
		if inventory[slot] == null:
			inventory[slot] = item
			Global.level.get_node("UI/Inventory/LevelInventoryButton" + str(slot)).update(inventory[slot])
			added = true
		else:
			if inventory[slot].item_name() == item.item_name():
				inventory[slot].quantity += item.quantity
				added = true
		if added:
			Global.level.get_node("UI/Inventory/LevelInventoryButton" + str(slot)).update(inventory[slot])
			return

func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent == null:
		return
	if not parent is LevelObject:
		return
	if parent.has_method("dropped_item"):
		if can_carry_item(parent.item_stack):
			carry_item(parent.item_stack)
			parent.queue_free()
