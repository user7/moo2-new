extends Node

@onready var map = $MarkerMap
@onready var menu = $GameMenu

var star_textures = []
var star_dialog = null

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
		scene.position = Vector2(s.pos)
		map.add_marker(scene)
		scene.connect("marker_clicked", func(): _on_star_clicked(sid))
	menu.hide()


func _on_game_pressed():
	menu.show()


func _on_return_pressed():
	menu.hide()


func _on_star_clicked(sid: int):
	var pos = Vector2.ZERO
	if star_dialog != null:
		pos = star_dialog.position
		star_dialog.queue_free()
	star_dialog = load("res://scenes/aux_star_dialog.tscn").instantiate()
	star_dialog.star_id = sid
	star_dialog.position = pos
	G.game.print_star(sid)
	map.add_child(star_dialog)


func _on_quit_pressed():
	Router.pop_scene()


func save_load(do_load: bool = false):
	Router.create_save_load_dialog(self, func(n, title): _on_save_load(n, title, do_load), do_load)


func _on_save_load(n: int, title: String, do_load: bool):
	if do_load:
		G.load_game(n)
		Router.pop_scene()
		Router.push_scene_main_screen()
		menu.hide()
		# TODO update main screen
	else:
		G.save_game(n, title)
		menu.hide()
		# close menu


func _on_save_pressed():
	save_load(false)


func _on_load_pressed():
	save_load(true)


func _on_game_menu_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		menu.hide()
