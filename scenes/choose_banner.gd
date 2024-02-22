extends Control


func _ready():
	for n in range(8):
		get_node("VBoxContainer/GridContainer/TextureButton%s" % n) \
			.connect("pressed", func (): _on_banner_selected(n))


func _on_banner_selected(n: int):
	G.game.get_current_player().banner = n
	Router.push_scene_new_game_wait()
