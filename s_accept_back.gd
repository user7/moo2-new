extends MarginContainer

signal accept_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_accept_pressed():
	accept_pressed.emit()

func _on_back_pressed():
	Router.pop_scene()
