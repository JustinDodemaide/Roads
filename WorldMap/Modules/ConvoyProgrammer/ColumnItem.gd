extends PanelContainer

func init(image,_name,amount = 0):
	$MarginContainer/HBoxContainer/Image.texture = image
	$MarginContainer/HBoxContainer/Name.text = _name
	if amount != 0:
		$MarginContainer/HBoxContainer/Amount.text = str(amount)
