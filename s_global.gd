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

func push_scene(path):
	call_deferred("_deferred_goto_scene", path)

func push_scene_stub():
	push_scene("res://s_stub.tscn")

func push_scene_new_game():
	push_scene("res://s_new_game_menu.tscn")

func push_race_selection():
	push_scene("res://s_race_selection_menu.tscn")

func _deferred_goto_scene(path):
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
