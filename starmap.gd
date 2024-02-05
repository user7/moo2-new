extends Node

@onready var camera = $SubViewportContainer/SubViewport/root/Camera2D
var arrows = [
	["move_left", 1, 0], ["move_right", -1, 0],
	["move_down", 0, -1], ["move_up", 0, 1]
]

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
	if event is InputEventMouseButton and event.pressed \
		and event.button_index == MOUSE_BUTTON_LEFT:
		var pos = event.position
		var center = get_viewport().size / 2
		var offset = Vector2(pos) - Vector2(center) 
		camera.position += offset

func input_zoom():
	return 1 if Input.is_action_just_pressed("zoom in") else \
		  -1 if Input.is_action_just_pressed("zoom out") else 0

func input_sum(actions: Array):
	var v = Vector2i.ZERO
	for a in actions:
		if Input.is_action_pressed(a[0]):
			v += Vector2i(a[1], a[2])
	return v

func _process(_delta):
	var shift = input_sum(arrows)
	var zoom = input_zoom()
	if shift != Vector2i.ZERO or zoom != 0:
		var cur_pos = camera.position
		var new_pos = cur_pos - shift * 10.
		var cur_zoom = camera.zoom
		var new_zoom = cur_zoom + Vector2(zoom, zoom) * 0.1
		for i in range(0, 2):
			new_zoom[i] = min(max(new_zoom[i], 0.2), 3)
		camera.position = new_pos
		camera.zoom = new_zoom
