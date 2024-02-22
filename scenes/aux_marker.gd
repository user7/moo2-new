extends Control

signal marker_clicked;


func set_label(text: String):
	$Label.text = "[center]" + text + "[/center]"


func set_texture(norm: Texture, high: Texture):
	var b = $TextureButton
	b.texture_normal = norm
	b.texture_pressed = high
	b.texture_hover = high


func _on_texture_button_pressed():
	marker_clicked.emit()
