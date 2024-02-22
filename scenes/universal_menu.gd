extends CanvasLayer

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var load_button: Button = $VBoxContainer/LoadGameButton

func _ready():
	var save_cont_exists = G.save_exists()
	var save_other_exist = false
	for i in range(1, 10):
		if G.save_exists(i):
			save_other_exist = true
			break
	continue_button.disabled = not save_cont_exists
	load_button.disabled = not save_other_exist


func _on_continue_button_pressed():
	if G.load_game():
		Router.push_scene_main_screen()


func _on_quit_game_button_pressed():
	Router.pop_scene()


func _on_new_game_button_pressed():
	Router.push_scene_new_game()
