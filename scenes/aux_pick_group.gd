extends PanelContainer

func set_label(text):
	$VBox/Label.text = text

func add_item(label, cost, enabled = false):
	var item = preload("res://scenes/aux_pick_item.tscn").instantiate()
	item.set_text(label, cost)
	item.set_enabled(enabled)
	$VBox.add_child(item)
	return item
