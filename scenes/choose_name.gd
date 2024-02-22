extends Control

func _ready():
	$VBoxContainer/LineEdit.text = G.game.get_current_player().name


func _on_accept():
	G.game.get_current_player().name = $VBoxContainer/LineEdit.text
	Router.push_scene_choose_banner()
