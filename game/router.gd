extends Node

var scene_stack = []
var scene_cur = null


func _ready():
	var root = get_tree().root
	scene_cur = root.get_child(root.get_child_count() - 1)
	scene_stack.push_back(["res://scenes/universal_menu.tscn", null])
	print("Router ready")


func pop_scene():
	push_scene(null, null, 1)


func push_scene(path, data = null, trim = 0):
	call_deferred("_deferred_goto_scene", path, data, trim)


func push_scene_stub():
	push_scene("res://scenes/stub.tscn")


func push_scene_new_game():
	push_scene("res://scenes/new_game_menu.tscn")


func push_scene_race_selection(data = null):
	push_scene("res://scenes/select_race_menu.tscn", data)


func push_scene_customize_race():
	push_scene("res://scenes/customize_race_menu.tscn", false)


func push_scene_choose_banner():
	push_scene("res://scenes/choose_banner.tscn")


func push_scene_choose_name():
	push_scene("res://scenes/choose_name.tscn")


func push_scene_new_game_wait():
	push_scene("res://scenes/new_game_wait.tscn")


func push_scene_main_screen():
	push_scene("res://scenes/main_screen.tscn")


func create_save_load_dialog(script, cb, do_load):
	var dialog = load("res://scenes/aux_save_load_dialog.tscn").instantiate()
	dialog.do_load = do_load
	dialog.connect("slot_selected", cb)
	script.add_child(dialog)


func squash_newgame_scenes():
	if scene_stack.size() >= 2:
		scene_stack = [scene_stack[0], scene_stack[-1]]


func _deferred_goto_scene(path, data, trim: int):
	scene_stack = scene_stack.slice(0, max(0, scene_stack.size() - trim))
	if path == null:
		if !scene_stack:
			get_tree().quit()
			return
		path = scene_stack[-1][0]
		data = scene_stack[-1][1]
	else:
		scene_stack.push_back([path, data])
	scene_cur.free()
	scene_cur = ResourceLoader.load(path).instantiate()
	get_tree().root.add_child(scene_cur)
	get_tree().current_scene = scene_cur
	if data != null:
		scene_cur.init_scene(data)
