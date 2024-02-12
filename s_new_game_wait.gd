extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var tot = 0;
var oldv = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	tot += delta
	var v = floor(tot * 100)
	if v != oldv and v <= 100:
		oldv = v
		$VBoxContainer/ProgressBar.value = v
		if v == 100:
			call_deferred("next_screen")

func next_screen():
	Router.push_scene_main_screen()
