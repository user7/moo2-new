extends Node

func _ready():
	get_tree().root.connect("size_changed", _on_viewport_size_changed)
	_on_viewport_size_changed()

func _on_viewport_size_changed():
	var svc = $SubViewportContainer
	var sv = $SubViewportContainer/SubViewport
	var sz = get_viewport().size
	print("viewport size set ", sz)
	svc.size = sz
	sv.size = sz
	svc.position = Vector2.ZERO
	
func input_dir(input: String, val: int) -> int:
	return val if Input.is_action_pressed(input) else 0

func input_axis(name_pos: String, name_neg: String) -> int:
	var v = input_dir(name_pos, -1) 
	return v if v else input_dir(name_neg, 1)

func input_vec(a: String, b: String, c: String, d: String):
	return Vector2(input_axis(a, b), input_axis(c, d))

func _process(_delta):
	var dir = input_vec("move_left", "move_right", "move_up", "move_down")
	if dir != Vector2.ZERO:
		var camera = $SubViewportContainer/SubViewport/root/Camera2D
		camera.position += dir * 10
