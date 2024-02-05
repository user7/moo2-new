extends Node

@onready var camera = $SubViewportContainer/SubViewport/root/Camera2D

func _ready():
	get_tree().root.connect("size_changed", _on_viewport_size_changed)
	_on_viewport_size_changed()

func _on_viewport_size_changed():
	var svc = $SubViewportContainer
	var sv = $SubViewportContainer/SubViewport
	var vsz = get_viewport().size
	print("viewport size set ", vsz)
	svc.size = vsz
	sv.size = vsz
	svc.position = Vector2.ZERO

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		var pos = event.position
		var center = get_viewport().size / 2
		var offset = Vector2(pos) - Vector2(center) 
		camera.position += offset
	
func input_dir(input: String, val: int) -> int:
	return val if Input.is_action_pressed(input) else 0

func input_axis(name_pos: String, name_neg: String) -> int:
	var v = input_dir(name_pos, 1)
	return v if v else input_dir(name_neg, -1)

func input_vec(a: String, b: String, c: String, d: String):
	return Vector2(input_axis(a, b), input_axis(c, d))

func input_zoom():
	if Input.is_action_just_pressed("zoom in"):
		return 1
	return -1 if Input.is_action_just_pressed("zoom out") else 0

func _process(_delta):
	var shift = input_vec("move_left", "move_right", "move_up", "move_down")
	var zoom = input_zoom()
	if shift != Vector2.ZERO or zoom != 0:
		var cur_pos = camera.position
		var new_pos = cur_pos - shift * 10
		var cur_zoom = camera.zoom
		var new_zoom = cur_zoom + Vector2(zoom, zoom) * 0.1
		for i in range(0, 2):
			new_zoom[i] = min(max(new_zoom[i], 0.2), 3)
		camera.position = new_pos
		camera.zoom = new_zoom
