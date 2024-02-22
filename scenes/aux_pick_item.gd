extends MarginContainer

signal clicked()

func set_text(checkbox_label, cost_label):
	$CheckBox.text = str(checkbox_label)
	$Label.text = str(cost_label)

func set_enabled(enabled):
	$CheckBox.button_pressed = enabled

func _on_clicked():
	clicked.emit()
