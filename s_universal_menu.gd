extends CanvasLayer

func _ready():
	pass

func _process(_delta):
	pass

func _on_continue_button_pressed():
	Global.push_scene_stub()

func _on_quit_game_button_pressed():
	Global.pop_scene()

func _on_new_game_button_pressed():
	Global.push_scene_new_game()
