extends Node2D

signal marker_clicked(id)

var id = null

func set_label(text: String):
	$Label.text = text

func set_texture(texture):
	var button = $TextureButton
	button.texture_normal = texture
	button.position = texture.get_size() / 2.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_texture_button_pressed():
	marker_clicked.emit(id)
