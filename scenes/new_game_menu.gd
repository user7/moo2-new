extends Control
	
var controls = [
	[
		"clickthrough",
		"settings difficulty",
		"CTDifficulty",
		"Difficulty",
		"res://img/ng_diff_%s.png",
		"Tutor",
		"Easy",
		"Average",
		"Hard",
		"Impossible",
	],
	[
		"clickthrough",
		"settings galaxy_size",
		"CTGalaxySize",
		"Galaxy Size",
		"res://img/ng_size_%s.png",
		"Small",
		"Medium",
		"Large",
		"Cluster",
		"Huge",
	],
	[
		"clickthrough",
		"settings galaxy_age",
		"CTGalaxyAge",
		"Galaxy Age",
		"res://img/ng_age_%s.png",
		"Mineral Rich",
		"Average",
		"Organic Rich",
	],
	[
		"clickthrough",
		"settings players",
		"CTPlayers",
		"Players",
		"res://img/ng_players_%s.png",
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
		"settings tech_level",
		"CTTechLevel",
		"Tech Level",
		"res://img/ng_tech_%s.png",
		"Pre Warp",
		"Average",
		"Post Warp",
		"Advanced",
	],
	[
		"checkbox",
		"settings tactical_combat",
		"PanelContainer/VBoxContainer/TacticalCombat",
	],
	[
		"checkbox",
		"settings antaran_attacks",
		"PanelContainer/VBoxContainer/AntaranAttacks",
	],
	[
		"checkbox",
		"settings random_events",
		"PanelContainer/VBoxContainer/RandomEvents",
	],
]


func load_controls():
	for c in controls:
		var type = c[0]
		var conf_val = Config.get_conf(c[1])
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
		Config.set_conf(c[1], value)
	Config.save_conf()


func _on_accept():
	save_controls()
	Router.push_scene_race_selection()
