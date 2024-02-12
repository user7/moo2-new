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


func _ready():
	for s in stars:
		var scene = ResourceLoader.load("res://scenes/marker.tscn").instantiate()
		scene.set_texture(
			load("res://svg/star_norm_%s.svg" % s[0]),
			load("res://svg/star_high_%s.svg" % s[0]))
		scene.set_label(s[1])
		scene.position = Vector2(s[2], s[3])
		map.add_marker(scene)
		scene.connect("marker_clicked", func(): _on_marker_clicked(s[0]))
	var menu = $GameMenu
	menu.hide()


func _on_game_pressed():
	$GameMenu.show()


func _on_return_pressed():
	$GameMenu.hide()


func _on_marker_clicked(id):
	print("marker %s clicked" % id)
