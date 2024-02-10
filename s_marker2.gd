extends Control

signal marker_clicked(id);

var id = null

func set_label(text: String):
	$Label.text = "[center]" + text + "[/center]"

func set_texture(norm: Texture, high: Texture):
	var b = $CenterContainer/TextureButton
	b.texture_normal = norm
	b.texture_pressed = high
	b.texture_hover = high

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_texture_button_pressed():
	marker_clicked.emit(id)
