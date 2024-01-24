extends CanvasLayer

var cts = [
	[
		"Difficulty",
		"res://img/ng_diff_%s.png",
		"Tutor",
		"Easy",
		"Average",
		"Hard",
		"Impossible",
	],
	[
		"Galaxy Size",
		"res://img/ng_size_%s.png",
		"Small",
		"Medium",
		"Large",
		"Cluster",
		"Huge",
	],
	[
		"Galaxy Age",
		"res://img/ng_age_%s.png",
		"Mineral Rich",
		"Average",
		"Organic Rich",
	],
	[
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
		"Tech Level",
		"res://img/ng_tech_%s.png",
		"Pre Warp",
		"Average",
		"Post Warp",
		"Advanced",
	],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	setup($PanelContainer/GridContainer/CTDifficulty, 0)
	setup($PanelContainer/GridContainer/CTGalaxySize, 1)
	setup($PanelContainer/GridContainer/CTGalaxyAge, 2)
	setup($PanelContainer/GridContainer/CTPlayers, 3)
	setup($PanelContainer/GridContainer/CTTechLevel, 4)

func setup(ct_scene, i):
	if cts.size() <= i:
		return
	var cti = cts[i]
	var pics = []
	var labels = []
	var caption = cti[0]
	var template = cti[1]
	for j in range(2, cti.size()):
		labels.push_back(cti[j])
		pics.push_back(template % (j - 2))
	ct_scene.set_data(caption, labels, pics)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
