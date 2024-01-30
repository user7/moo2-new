extends Node

var scene_stack = ["res://s_universal_menu.tscn"]
var scene_cur = null

func _ready():
	var root = get_tree().root
	scene_cur = root.get_child(root.get_child_count() - 1)
	print("started, scene: ", scene_cur)

func _process(_delta):
	pass

func pop_scene():
	push_scene(null)

func push_scene(path, data = null):
	call_deferred("_deferred_goto_scene", path, data)

func push_scene_stub():
	push_scene("res://s_stub.tscn")

func push_scene_new_game():
	push_scene("res://s_new_game_menu.tscn")

func push_scene_race_selection(data = null):
	push_scene("res://s_race_selection_menu.tscn", data)

func push_scene_choose_banner():
	push_scene("res://s_choose_banner.tscn")

func push_scene_choose_name():
	push_scene("res://s_choose_name.tscn")

func push_scene_new_game_wait():
	push_scene("res://s_new_game_wait.tscn")

func push_scene_main_screen():
	push_scene("res://s_main_screen.tscn")

# init null or callable
func _deferred_goto_scene(path, data):
	if path == null and scene_stack.size() == 0:
		return
	scene_cur.free()
	if path == null:
		scene_stack.pop_back()
		if !scene_stack:
			get_tree().quit()
			return
		path = scene_stack[-1]
	else:
		scene_stack.push_back(path)
	scene_cur = ResourceLoader.load(path).instantiate()
	get_tree().root.add_child(scene_cur)
	get_tree().current_scene = scene_cur
	if data != null:
		scene_cur.init_scene(data)
