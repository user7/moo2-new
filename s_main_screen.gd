extends Node

@onready var map = $MarkerMap

var stars = [
	[0, "Blue", 100, 100],
	[1, "White", 200, 200],
	[2, "Yellow", 300, 500],
	[3, "Orange", 100, 300],
	[4, "Red", 300, 100],
	[5, "Brown", 200, 400],
	[6, "Black Hole", 500, 500],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for s in stars:
		var scene = ResourceLoader.load("res://s_marker.tscn").instantiate()
		scene.set_texture(load("res://img/star-%s.png" % s[0]))
		scene.set_label(s[1])
		map.add_marker(scene, Vector2(s[2], s[3]))
	var menu = $GameMenu
	menu.hide()

func _process(_delta):
	pass

func _on_game_pressed():
	$GameMenu.show()

func _on_return_pressed():
	$GameMenu.hide()
