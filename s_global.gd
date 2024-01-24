extends Node

var stack = ["res://s_universal_menu.tscn"]
var cur_scene = null

func _ready():
	var root = get_tree().root
	cur_scene = root.get_child(root.get_child_count() - 1)
	print("started, scene: ", cur_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pop_scene():
	push_scene(null)

func push_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	cur_scene.free()
	if path == null:
		stack.pop_back()
		if !stack:
			get_tree().quit()
			return
		path = stack[-1]
	else:
		stack.push_back(path)
	cur_scene = ResourceLoader.load(path).instantiate()
	get_tree().root.add_child(cur_scene)
	get_tree().current_scene = cur_scene
