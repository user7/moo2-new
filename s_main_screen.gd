extends Node

@onready var map = $MarkerMap

var stars = [
	[0, "Elena", 100, 100],
	[1, "Quisha", 200, 200],
	[2, "Marin", 300, 300],
	[3, "Quora", 100, 300],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for s in stars:
		var scene = ResourceLoader.load("res://s_marker.tscn").instantiate()
		scene.set_texture(load("res://img/star-%s.png" % s[0]))
		scene.position = Vector2(s[2], s[3])
		scene.set_name(s[1])
		map.add_child(scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
