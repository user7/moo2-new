extends Node

const default_tree = {
	settings = {
		difficulty = 0,
		galaxy_size = 2,
		galaxy_age = 1,
		players = 7,
		tech_level = 0,
		tactical_combat = 1,
		antaran_attacks = 0,
		random_events = 1,
		last_race = {
			growth = 0,
			farming = 0,
		}
	}
}
var tree = default_tree.duplicate(true)
const settings_file = "user://settings.dat"


func _ready():
	load_conf()
	print("Config ready")


func trace_path_rec(p: PackedStringArray, i: int, node: Dictionary, set_to = null):
	var key = p[i]
	var val = node.get(key)
	if val == null:
		print("trace_path: invalid path: ", p, " i=", i, " node=", node)
		return null
	if i == p.size() - 1:
		if val is Dictionary:
			print("trace_path: attempt to access non-leaf node: ", p)
			return null
		if set_to == null:
			return val
		node[key] = set_to
		return set_to
	if val is Dictionary:
		return trace_path_rec(p, i + 1, val, set_to)
	print("trace_path: attempt to descend below leaf node ", p, " i=", i)
	return null


func trace_path(path: String, value = null):
	var p = path.split(" ", false)
	if p:
		return trace_path_rec(p, 0, tree, value)
	print("trace_path: empty path ", path)
	return null


func get_conf(path: String):
	return trace_path(path);


func set_conf(path: String, value):
	return trace_path(path, value);


func save_conf():
	FileAccess.open(settings_file, FileAccess.WRITE).store_var(tree)


func validate_conf(node: Dictionary, template: Dictionary):
	for key in node:
		if key not in template:
			node.erase(key)
			continue
		var node2 = node[key]
		var template2 = template[key]
		if node2 is Dictionary and template2 is Dictionary:
			validate_conf(node2, template2)
		elif template2 is Dictionary:
			print("validate_conf: overwriting value with dict ", node2, " > ", template2)
			node[key] = template2.duplicate(true)
		elif node2 is Dictionary:
			print("validate_conf: overwriting dict with value ", node2, " > ", template2)
			node[key] = template2


func load_conf():
	var file = FileAccess.open(settings_file, FileAccess.READ)
	if file != null:
		tree = file.get_var()
	validate_conf(tree, default_tree)
