extends Node

@onready var camera = $SubViewportContainer/SubViewport/root/Camera2D
@onready var map_root = $SubViewportContainer/SubViewport/root
@onready var svc = $SubViewportContainer
@onready var sv = $SubViewportContainer/SubViewport
@onready var galaxy_rect = $SubViewportContainer/SubViewport/root/test/Galaxy
var last_mouse: Vector2 = Vector2.ZERO
var cur_zoom: int = 1
var map_size: Vector2
var win_size: Vector2i
const eps = 0.00001

func _ready():
	if G.game == null:
		G.generate_test_game()
	map_size = G.game.size
	galaxy_rect.size = map_size
	get_tree().root.connect("size_changed", on_viewport_size_changed)
	on_viewport_size_changed()
	var z = camera.zoom[0]
	update_pos((map_size * z - win_size * 1.) / 2. / z)

func on_viewport_size_changed():
	win_size = get_viewport().size
	svc.size = win_size
	sv.size = win_size
	svc.position = Vector2.ZERO
	update_zoom(0)

func update_zoom(step: int, point = null):
	var new_zoom = cur_zoom + step
	if new_zoom > 100:
		new_zoom = 0
		return
	var ocz = camera.zoom[0]
	var coef = 1. / (1 - new_zoom) if new_zoom <= 0 else new_zoom + 1.
	camera.zoom = U.cvec2(coef)
	var ncz = camera.zoom[0]
	cur_zoom = new_zoom
	if point != null:
		var delta_pos = point * (1 / ocz - 1 / ncz)
		update_pos(delta_pos)

func update_pos(delta_pos):
	var new_pos = camera.position + delta_pos
	camera.position = new_pos

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		last_mouse = event.position
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		update_pos((event.position - win_size / 2.) / camera.zoom[0])

func _process(_delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"): direction.x = 1
	if Input.is_action_pressed("ui_up"): direction.y = -1
	if Input.is_action_pressed("ui_left"): direction.x = -1
	if Input.is_action_pressed("ui_down"): direction.y = 1
	if direction != Vector2.ZERO:
		update_pos(direction * 10. / camera.zoom[0])

	var dscale: int = 0
	if Input.is_action_just_pressed("zoom in"): dscale = 1
	if Input.is_action_just_pressed("zoom out"): dscale = -1
	if dscale != 0:
		update_zoom(dscale, last_mouse)

func add_marker(marker: Control):
	marker.scale *= 0.25
	map_root.add_child(marker)
