extends Node

@onready var map = $MarkerMap

var stars = [
	[0, "Elena", 100, 100],
	[1, "Kiji", 200, 200],
	[2, "Marin", 300, 500],
	[3, "Quaz", 100, 300],
	[4, "Otter", 300, 100],
	[5, "Katz", 200, 400],
	[6, "Irma", 500, 500],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for s in stars:
		var scene = ResourceLoader.load("res://s_marker.tscn").instantiate()
		scene.set_texture(load("res://img/star-%s.png" % s[0]))
		scene.set_label(s[1])
		map.add_marker(scene, Vector2(s[2], s[3]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
