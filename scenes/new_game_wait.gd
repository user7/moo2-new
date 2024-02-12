extends Control

var tot = 0;
var oldv = 0;


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
