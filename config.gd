extends Node

var tree = {
	"settings" : {
		"difficulty" : 0,
		"galaxy_size" : 2,
		"galaxy_age" : 1,
		"players" : 7,
		"tech_level" : 0,
		"tactical_combat" : 1,
		"antaran_attacks" : 0,
		"random_events" : 1,
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Config ready")

func split_path(path: String):
	return path.split(" ", false)

func trace_path_rec(p: PackedStringArray, i: int, node: Dictionary, set_to = null):
	var key = p[i]
	var val = node.get(key)
	if val == null:
		print("trace_path: invalid path: ", p.slice(0, i + 1))
		return	
	if i == p.size() - 1:
		if set_to != null:
			node[key] = set_to
			return set_to
		elif val is Dictionary:
			print("trace_path: attempt to access non-leaf node: ", p)
			return
		else:
			return val
	return trace_path_rec(p, i + 1, val, set_to)

func trace_path(path: String, value = null):
	var p: PackedStringArray = split_path(path)
	if p:
		return trace_path_rec(p, 0, tree, value)
	print("trace_path: empty path ", path)
	return null
	
func get_conf(path: String):
	return trace_path(path);

func set_conf(path: String, value):
	return trace_path(path, value);
