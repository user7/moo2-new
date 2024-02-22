extends Control

@onready var seed_edit = $PanelContainer/VBoxContainer/GridContainer/PanelContainer/VBoxContainer/HBoxContainer/LineEdit
var rng = RandomNumberGenerator.new()

const controls = [
	[
		"clickthrough",
		"difficulty",
		"CTDifficulty",
		"Difficulty",
		"res://img/new_game/diff/%s.png",
		"Tutor",
		"Easy",
		"Average",
		"Hard",
		"Impossible",
	],
	[
		"clickthrough",
		"galaxy_size",
		"CTGalaxySize",
		"Galaxy Size",
		"res://img/new_game/size/%s.png",
		"Small",
		"Medium",
		"Large",
		"Cluster",
		"Huge",
	],
	[
		"clickthrough",
		"galaxy_age",
		"CTGalaxyAge",
		"Galaxy Age",
		"res://img/new_game/age/%s.png",
		"Mineral Rich",
		"Average",
		"Organic Rich",
	],
	[
		"clickthrough",
		"players",
		"CTPlayers",
		"Players",
		"res://img/new_game/players/%s.png",
		"2 Players",
		"3 Players",
		"4 Players",
		"5 Players",
		"6 Players",
		"7 Players",
		"8 Players",
		"Random",
	],
	[
		"clickthrough",
		"tech_level",
		"CTTechLevel",
		"Tech Level",
		"res://img/new_game/tech/%s.png",
		"Pre Warp",
		"Average",
		"Post Warp",
		"Advanced",
	],
	[
		"checkbox",
		"tactical_combat",
		"PanelContainer/VBoxContainer/TacticalCombat",
	],
	[
		"checkbox",
		"antaran_attacks",
		"PanelContainer/VBoxContainer/AntaranAttacks",
	],
	[
		"checkbox",
		"random_events",
		"PanelContainer/VBoxContainer/RandomEvents",
	],
]


func load_controls():
	for c in controls:
		var type = c[0]
		var conf_val = G.get_setting(c[1])
		var scene = get_node("PanelContainer/VBoxContainer/GridContainer/" + c[2])
		if type == "clickthrough":
			var caption = c[3]
			var template = c[4]
			var pics = []
			var labels = []
			const slice_start = 5
			for j in range(slice_start, c.size()):
				labels.push_back(c[j])
				pics.push_back(template % (j - slice_start))
			scene.init_clickthrough(caption, labels, pics, conf_val)
		elif type == "checkbox":
			scene.button_pressed = conf_val != 0
		else:
			print("unknown control type: ", type)


func _ready():
	load_controls()


func save_controls():
	for c in controls:
		var type = c[0]
		var scene = get_node("PanelContainer/VBoxContainer/GridContainer/" + c[2])
		var value = null
		if type == "checkbox":
			value = 1 if scene.button_pressed else 0
		elif type == "clickthrough":
			value = scene._cur_val
		G.set_setting(c[1], value)
	G.save_settings()


func _on_accept():
	save_controls() # saves to settings
	var g = G.default_game() # reads settings
	g.rng_seed = int(seed_edit.text)
	G.game = g 
	Router.push_scene_race_selection()


func _randomize_seed():
	seed_edit.text = str(rng.randi_range(0, 0x7FFFFFFF))
