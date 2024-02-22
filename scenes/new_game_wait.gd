extends Control

func _ready():
	G.generate_universe_update.connect(_on_progress)
	G.generate_universe_mt()
	

func _on_progress(cur: int, tot: int):
	if tot > 0:
		$VBoxContainer/ProgressBar.value = cur * 100 / tot;
		if cur == tot:
			Router.push_scene_main_screen()

func _process(delta):
	pass

func _on_cancel():
	G.generate_universe_mt_cancel()
	Router.pop_scene()
