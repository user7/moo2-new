extends Control

var cur_portrait = 13
var select_face = false


func _ready():
	for i in range(0, 14):
		var button = get_node("VBox/HBox/Choice/Buttons/Button%s" % i)
		button.connect("pressed", func(): _on_nth(i, true))
		button.connect("mouse_entered", func(): _on_nth(i, false))
	if G.game == null:
		G.game = G.default_game()
	if G.game.cur_player_id == G.NOID:
		G.game.cur_player_id = G.game.add_player()


func _on_back_pressed():
	Router.pop_scene()


func _on_nth(n: int, pressed: bool):
	var std_races = G.game.config.standard_races
	var race: G.Race
	if n < std_races.size():
		race = std_races[n]
	elif n == 13:
		race = G.game.settings.last_race
	else:
		race = G.Race.new()

	var picks = G.game.config.picks
	var race_desc = picks["government"].options[race.traits.government - 1].label
	for p in picks:
		if p != "government":
			var v = int(race.traits.get(p))
			if v > 0:
				race_desc = race_desc + ", " + picks[p].options[v - 1].label

	if pressed:
		var r = U.clone(race)
		var p: G.Player = G.game.get_current_player()
		p.race = G.game.add_race(race)
		p.picture = n
		p.name = "%s Boss" % r.name
		if select_face:
			Router.push_scene_customize_race()
		elif n == 13:
			Router.push_scene_race_selection(true)
		else:
			Router.push_scene_choose_name()
	elif cur_portrait != n:
		cur_portrait = n
		$VBox/HBox/Info/Portrait.texture = load("res://img/race/%s.png" % n)
		var stats = $VBox/HBox/Info/RaceStats
		if select_face:
			stats.text = race_desc
		else:
			stats.text = "" if n == 13 else race_desc

func init_scene(data: bool):
	select_face = data
	var cur = cur_portrait
	cur_portrait = -1
	$VBox/HBox/Choice/Label.text = "Select Race Picture"
	$VBox/HBox/Choice/Buttons/Button13.text = "Last Race"
	_on_nth(cur, false)
