extends PanelContainer

signal upgrade_producer(resource:Item)

var res:WO_Resource

func init(resource:WO_Resource):
	res = resource
	var name_label = $HBoxContainer/Label
	var tier_label = $HBoxContainer/VBoxContainer/Tier
	var rate_label = $HBoxContainer/VBoxContainer/Rate
	var button = $HBoxContainer/UpgradeButton
	name_label.text = resource.item_name
	tier_label.text = "Production tier: " + str(resource.production_tier)
	if resource.production_tier != -1:
		var quantity:String = str(resource.production_rates[resource.production_tier])
		rate_label.text = quantity + " " + resource.item_name + "(s) per turn"
	if resource.production_tier == resource.max_tiers:
		button.disabled = true
		button.text = "Max tier!"
	visible = true

func _on_upgrade_button_pressed():
	Global.player_faction.inventory["Gold"] -= 1
	res.production_tier += 1
	init(res)
