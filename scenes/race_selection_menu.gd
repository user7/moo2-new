extends Control

var cur_portrait = 13
var select_face = false


func _ready():
	for i in range(0, 14):
		var button = get_node("VBox/HBox/Choice/Buttons/Button%s" % i)
		button.connect("pressed", func(): _on_nth(i, true))
		button.connect("mouse_entered", func(): _on_nth(i, false))


func _on_back_pressed():
	Router.pop_scene()


func _on_nth(n: int, pressed: bool):
	if pressed:
		if select_face:
			Router.push_scene_stub() # racial picks
		elif n == 13:
			Router.push_scene_race_selection(true)
		else:
			Router.push_scene_choose_name()
	elif cur_portrait != n:
		cur_portrait = n
		$VBox/HBox/Info/Portrait.texture = load("res://img/race_image_%s.png" % n)
		var stats = $VBox/HBox/Info/RaceStats
		if select_face:
			stats.text = "" if n != 13 else "last race picks"
		else:
			stats.text = "" if n == 13 else "race #%s description" % n


func init_scene(data: bool):
	select_face = data
	var cur = cur_portrait
	cur_portrait = -1
	$VBox/HBox/Choice/Label.text = "Select Race Picture"
	_on_nth(cur, false)
