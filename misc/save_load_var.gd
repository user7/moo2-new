extends Node2D


func _ready():
	var v1 = {a=1, b=2, c=3}
	var v2 = {d=22, e=33}
	var file = FileAccess.open("saves/test.gam", FileAccess.WRITE)
	file.store_var(v1)
	file.store_var(v2)
	#
	var file2 = FileAccess.open("saves/test.gam", FileAccess.READ)
	var v3 = file2.get_var()
	var v4 = file2.get_var()
	print("read %s %s >>> %s %s" % [v1, v2, v3, v4])
	#
	var file3 = FileAccess.open("saves/nonexistent.gam", FileAccess.READ)
	print(file3)

func _process(delta):
	pass
