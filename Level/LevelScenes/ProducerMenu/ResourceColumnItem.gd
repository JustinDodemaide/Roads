extends PanelContainer

func init(resource:Item,producers:Array[Producer]):
	var label = $HBoxContainer/Label
	var button = $HBoxContainer/ProducerButton
	label.text = resource.item_name()
	for producer in producers:
		for rate in producer.item_rates:
			if rate.item.equals(resource):
				# If this resource is already being harvested, don't
				# allow another harvester to be made
				button.disabled = true
				return



func _on_producer_button_pressed():
	pass # Replace with function body.
