extends MarginContainer

signal accept_pressed


func _on_accept_pressed():
	accept_pressed.emit()


func _on_back_pressed():
	Router.pop_scene()
