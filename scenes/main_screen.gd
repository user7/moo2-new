extends Node

@onready var map = $MarkerMap
@onready var menu = $GameMenu

var star_textures = []
var system_dialog = null

func _ready():
	Router.squash_newgame_scenes()
	for c in range(7):
		star_textures.push_back([])
		for t in ["norm", "high"]:
			star_textures[-1].push_back(load("res://img/star/%s/%s.svg" % [t, c]))
	var stars = G.game.stars
	var planets = G.game.planets
	for sid in stars:
		var s: G.Star = stars[sid]
		var scene = preload("res://scenes/aux_marker.tscn").instantiate()
		var txt = star_textures[s.color]
		scene.set_texture(txt[0], txt[1])
		scene.set_label(s.name)
		scene.position = Vector2(s.pos) * G.map_scale_value
		map.add_marker(scene)
		scene.connect("marker_clicked", func(): _on_star_clicked(sid))
	menu.hide()


func _on_game_pressed():
	menu.show()


func _on_return_pressed():
	menu.hide()


func _on_star_clicked(sid: int):
	var pos = Vector2.ZERO
	if system_dialog != null:
		pos = system_dialog.position
		system_dialog.queue_free()
	system_dialog = load("res://scenes/aux_star_dialog.tscn").instantiate()
	system_dialog.star_id = sid
	system_dialog.position = pos
	map.add_child(system_dialog)


func _on_quit_pressed():
	Router.pop_scene()
