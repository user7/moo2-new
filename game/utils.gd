extends Node

class PropInfo:
	var name
	var is_object = false
	var is_array = false
	var is_dictionary = false
	var subtype = null
	func _init(_name):
		name = _name
	func _to_string():
		return str("{name=", name,
			",is_array=", is_array,
			",is_dict=", is_dictionary,
			",is_object=", is_object, 
			"}")

class TypeInfo:
	var type
	var name
	var prop_extra: Dictionary
	var prop_list: Array[PropInfo] = []
	var prop_map: Dictionary = {}
	func _init(_type, _name, _prop_extra = {}):
		type = _type
		name = _name
		prop_extra = _prop_extra
	func _to_string():
		return str("{name=", name, ",props=", prop_list, ",prop_map=", prop_map, "}")

var type_map = {}    # index in type_list
var type_list = []   # array of TypeInfo

func is_builtin_type(val) -> bool:
	return val == null or \
		val is bool or \
		val is int or \
		val is float or \
		val is String or \
		val is Vector2i or \
		val is Vector2 or \
		val is Vector3 or \
		val is Rect2 or \
		val is Rect2i or \
		false
#transform2d
#plane
#quaternion
#aabb
#basis
#transform3d
#color
#node path
#rid
#object
#dictionary
#array
#raw array
#int32 array
#int64 array
#float32 array
#float64 array
#string array
#vector2 array
#vector3 array
#color array
#max

func register_type(type, type_name, prop_extra = {}) -> int:
	if not type_map.has(type):
		type_map[type] = type_list.size()
		type_list.append(TypeInfo.new(type, type_name, prop_extra))
	return type_map[type]

func init_registered_types():
	for t in type_list:
		var tmp = t.type.new()
		var info = type_list[tmp.typeid]
		var props = tmp.get_property_list()
		for pi in range(3, props.size()):
			var prop_info = PropInfo.new(props[pi]["name"])
			var val = tmp.get(prop_info.name)
			if val is Array:
				prop_info.is_array = true
			elif val is Dictionary:
				prop_info.is_dictionary = true
			elif not is_builtin_type(val):
				prop_info.is_object = val.typeid != null
			prop_info.subtype = info.prop_extra.get(prop_info.name, null)
			info.prop_list.append(prop_info)
			info.prop_map[prop_info.name] = info.prop_list[-1]

func clone(obj):
	var type_info = type_list[obj.typeid]
	var ret = type_info.type.new()
	for prop_info in type_info.prop_list:
		var val = obj.get(prop_info.name)
		var copy # a simple or a deep copy depending on type
		if prop_info.is_array:
			if not prop_info.subtype:
				copy = val.duplicate()
			else:
				copy = []
				for e in val:
					copy.push_back(clone(e))
		elif prop_info.is_dictionary:
			if not prop_info.subtype:
				copy = val.duplicate()
			else:
				copy = {}
				for k in val:
					copy[k] = clone(val[k])
		elif prop_info.is_object:
			copy = clone(val)
		else:
			copy = val
		ret.set(prop_info.name, copy)
	return ret

func obj_save(obj) -> Dictionary:
	var ret = {}
	#print("obj_save typeid ", obj.typeid)
	for prop_info in type_list[obj.typeid].prop_list:
		#print("prop_info.name ", prop_info.name)
		var val = obj.get(prop_info.name)
		var save = val
		if prop_info.is_object:
			save = obj_save(val)
		elif prop_info.is_array:
			if prop_info.subtype:
				save = []
				for v in val:
					save.push_back(obj_save(v))
		elif prop_info.is_dictionary:
			if prop_info.subtype:
				save = {}
				for k in val:
					save[k] = obj_save(val.get(k))
		ret[prop_info.name] = save
	return ret

func obj_load(obj, dict, do_print = false):
	var prop_map = type_list[obj.typeid].prop_map
	for key in dict:
		var val = dict[key]
		if not prop_map.has(key):
			print("obj_load skipping unknown key=", key, " val=", val)
			continue
		var prop_info: PropInfo = prop_map[key]

		if prop_info.is_object:
			if not val is Dictionary:
				print("obj_load skipping object key=", key, ", expected dictionary")
				continue
			obj_load(obj.get(prop_info.name), val)
			continue

		if prop_info.is_array:
			if not val is Array:
				print("obj_load skipping array key=", key, ", expected array")
				continue
			var prop = obj.get(prop_info.name)
			prop.clear()
			if prop_info.subtype:
				for v in val:
					var o = prop_info.subtype.new()
					obj_load(o, v)
					prop.push_back(o)
			else:
				prop.append_array(val)
			continue
		
		if prop_info.is_dictionary:
			if not val is Dictionary:
				print("obj_load skipping dictionary key=", key, ", expected dictionary")
				continue
			var prop = obj.get(prop_info.name)
			prop.clear()
			if prop_info.subtype:
				for k in val:
					var o = prop_info.subtype.new()
					obj_load(o, val[k])
					prop[k] = o
			else:
				prop.merge(val, true)
			continue
		
		obj.set(prop_info.name, val)

func obj_prop_get(obj, prop_name: String):
	if prop_name in type_list[obj.typeid].prop_map:
		return obj.get(prop_name)
	return null

func obj_prop_set(obj, prop_name: String, val):
	if prop_name in type_list[obj.typeid].prop_map:
		obj.set(prop_name, val)

func obj_props(obj):
	var props = []
	for p: PropInfo in type_list[obj.typeid].prop_list:
		props.append(p.name)
	return props

func obj_fill(obj, args):
	var props = type_list[obj.typeid].prop_list
	for i in props.size():
		if i >= args.size():
			return
		obj_prop_set(obj, props[i].name, args[i])
	return obj

func array(size: int, value = 0) -> Array[int]:
	var a: Array[int] = []
	a.resize(size)
	a.fill(int(value))
	return a

func _ready():
	print("Utils ready")	

func cvec2i(v: int = 0):
	return Vector2i(v, v)

func cvec2(v: float  = 0):
	return Vector2(v, v)
