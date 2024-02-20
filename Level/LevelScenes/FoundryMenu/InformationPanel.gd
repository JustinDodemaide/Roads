extends PanelContainer

@export var info_label:Label
@export var amount_label:Label
@export var accept_button:Button

@export var minus_button:Button
@export var plus_button:Button

var item:Item
var amount:int = 1
var cost:Dictionary

#@export var cost:Dictionary
#@export var build_time:int
func init(_item:Item):
	item = _item
	visible = true
	reset()
	get_cost()

func get_cost():
	var text:String = "Cost: "
	for string in item.cost:
		cost[string] = item.cost[string] * amount
		text += "\n" + string + " (" + str(cost[string]) + ")"
	info_label.text = text
	
	if cost_is_valid():
		accept_button.disabled = false
	else:
		accept_button.disabled = true

func reset():
	amount = 1
	amount_label.text = "1"
	minus_button.disabled = true

func _on_minus_pressed():
	amount -= 1
	amount_label.text = str(amount)
	if amount == 1:
		minus_button.disabled = true
	get_cost()

func _on_plus_pressed():
	amount += 1
	amount_label.text = str(amount)
	if amount > 1:
		minus_button.disabled = false
	get_cost()

func cost_is_valid() -> bool:
	var inventory = Global.player_faction.inventory
	for string in cost:
		if not inventory.has(string):
			return false
		if inventory[string] < cost[string]:
			return false
	return true
