extends Control

var cur_portrait = 13
var select_face = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 14):
		var button = get_node("VBox/HBox/Choice/Buttons/Button%s" % i)
		button.connect("pressed", func(): _on_nth(i, true))
		button.connect("mouse_entered", func(): _on_nth(i, false))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_back_pressed():
	Global.pop_scene()
	pass # Replace with function body.

func _on_nth(n: int, pressed: bool):
	if pressed:
		if select_face:
			Global.push_scene_stub() # racial picks
		elif n == 13:
			Global.push_scene_race_selection(true)
		else:
			Global.push_scene_choose_name()
	elif cur_portrait != n:
		cur_portrait = n
		$VBox/HBox/Info/Portrait.texture = load("res://img/race_image_%s.png" % n)
		if select_face:
			$VBox/HBox/Info/RaceStats.text = "" if n != 13 else "last race picks"
		else:
			$VBox/HBox/Info/RaceStats.text = "" if n == 13 \
					else "race #%s description" % n

func init_scene(data: bool):
	select_face = data
	var cur = cur_portrait
	cur_portrait = -1
	$VBox/HBox/Choice/Label.text = "Select Race Picture"
	_on_nth(cur, false)
