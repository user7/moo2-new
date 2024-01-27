extends Control

var cur_portrait = 13

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 14):
		var button = get_node("HBox/Choice/Buttons/Button%s" % i)
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
		if n == 0:
			Global.push_scene_stub() # custom race
		else:
			Global.push_scene_stub() # mapgen
	elif cur_portrait != n:
		cur_portrait = n
		var imgn = 13 if n == 0 else n / 2 if n % 2 else n / 2 + 6 # TODO
		$HBox/Info/Portrait.texture = load("res://img/race_image_%s.png" % imgn)
		$HBox/Info/RaceStats.text = "" if imgn == 13 \
				else "race #%s stat list description" % imgn
