extends CanvasLayer

func _ready():
	pass

func _process(delta):
	pass

func _on_continue_button_pressed():
	Global.push_scene("res://s_nothing.tscn")

func _on_quit_game_button_pressed():
	Global.pop_scene()
