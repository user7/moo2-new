extends CanvasLayer


func _on_continue_button_pressed():
	Router.push_scene_stub()


func _on_quit_game_button_pressed():
	Router.pop_scene()


func _on_new_game_button_pressed():
	Router.push_scene_new_game()
