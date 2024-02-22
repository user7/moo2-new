extends Node

@onready var camera = $SubViewportContainer/SubViewport/root/Camera2D
@onready var map_root = $SubViewportContainer/SubViewport/root
@onready var svc = $SubViewportContainer
@onready var sv = $SubViewportContainer/SubViewport

var last_mouse: Vector2 = Vector2.ZERO
var zoom_min: float = 0.01
var zoom_max: float = 1
var map_size: Vector2
var win_size: Vector2i
const eps = 0.00001


func _ready():
	if G.game == null:
		G.generate_test_game()
	map_size = Vector2(G.game.size * G.map_scale_value)
	get_tree().root.connect("size_changed", on_viewport_size_changed)
	on_viewport_size_changed()


func on_viewport_size_changed():
	win_size = get_viewport().size
	svc.size = win_size
	sv.size = win_size
	svc.position = Vector2.ZERO
	var c = 1. # TODO
	zoom_min = max(win_size[0] / c / map_size[0], win_size[1] / c / map_size[1])
	zoom_max = max(1, zoom_min)
	update_zoom(zoom_min)
	# print(camera.position)


func update_zoom(zoom: float, point = null):
	var old_zoom = camera.zoom[0]
	var new_zoom = clamp(zoom, zoom_min, zoom_max)
	if abs(old_zoom - new_zoom) < eps:
		return
	camera.zoom = Vector2(new_zoom, new_zoom)
	if point != null:
		var delta_pos = point * (1 / old_zoom - 1 / new_zoom)
		update_pos(delta_pos)


func update_pos(delta_pos):
	# print(delta_pos)
	var new_pos = camera.position + delta_pos
	var big_box = map_size * camera.zoom[0]
	var margin = big_box * 0.1
	var cur_box = win_size * 1. / G.map_scale_value
	var max_pos = big_box + margin - cur_box
	for i in 2:
		new_pos[i] = min(max(-margin[i], new_pos[i]), max(-margin[i], max_pos[i]))
	camera.position = new_pos


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		last_mouse = event.position
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		update_pos(event.position - win_size / 2.)


func _process(_delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"): direction.x = -1
	if Input.is_action_pressed("ui_up"): direction.y = 1
	if Input.is_action_pressed("ui_left"): direction.x = 1
	if Input.is_action_pressed("ui_down"): direction.y = -1
	if direction != Vector2.ZERO:
		update_pos(direction * 10.)

	var dscale = 0
	if Input.is_action_just_pressed("zoom in"): dscale = 0.2
	if Input.is_action_just_pressed("zoom out"): dscale = -0.2
	if dscale != 0:
		update_zoom(camera.zoom[0] + dscale, last_mouse)


func add_marker(marker):
	map_root.add_child(marker)
