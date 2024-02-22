extends Control

var initialized = false
var race_traits: G.Race
var checkboxes = {}
var evo_bonus_present = false

func init_scene(evo_bonus: bool):
	evo_bonus_present = evo_bonus
	if initialized:
		return
	var flow = $VBoxContainer/VFlowContainer
	var group_scene = preload("res://scenes/aux_pick_group.tscn")
	var race = G.game.races[G.game.get_current_player().race]
	$VBoxContainer/RaceName.text = race.name
	race_traits = race.traits
	for g in G.gui_pick_groups:
		var scene = group_scene.instantiate()
		scene.set_label(g.label)
		for opt_ref in g.option_refs:
			var pick_id = opt_ref.pick_id
			var option_id = opt_ref.option_id
			var pick: G.Pick = G.config.picks[pick_id]
			var option = pick.options[option_id]
			var last_value = race_traits.get(pick_id)
			var is_checked = last_value == option_id + 1
			var item = scene.add_item(option.label, option.cost, is_checked)
			item.connect("clicked", func (): on_item_clicked(pick_id, option_id))
			checkboxes[[pick_id, option_id]] = item
		flow.add_child(scene)
	recalc_picks()
	initialized = true

func recalc_picks():
	var picks = G.config.picks
	var tot_cost = 0
	var neg_cost = 0
	var starting_picks = G.config.number_of_race_picks.maximum_positive_picks
	var max_neg_picks = G.config.number_of_race_picks.maximum_negative_picks
	var evo_bonus = G.config.number_of_race_picks.evolutionary_mutation_bonus if evo_bonus_present else 0
	for pid in picks:
		var option_id = race_traits.get(pid) - 1
		if option_id != -1:
			var cost = picks[pid].options[option_id].cost
			tot_cost += cost
			if cost < 0:
				neg_cost += cost
	var total = starting_picks + evo_bonus - tot_cost
	var good = neg_cost >= max_neg_picks and total >= 0
	var score = 0 if total < -10 else (total + 10) * 10
	$VBoxContainer/HBoxContainer/Accept.disabled = not good
	$VBoxContainer/HBoxContainer/PicksVal.text = str(total)
	$VBoxContainer/HBoxContainer/ScoreVal.text = str("%s%%" % score)

func on_item_clicked(pick_id, option_id):
	var pick: G.Pick = G.config.picks[pick_id]
	var option = pick.options[option_id]
	var cur_option_id = race_traits.get(pick_id) - 1
	var check_conflicts = false
	if pick.options.size() > 1:
		if option_id == cur_option_id:
			if pick.required:
				checkboxes[[pick_id, option_id]].set_enabled(true)
			else:
				race_traits.set(pick_id, 0)
				checkboxes[[pick_id, option_id]].set_enabled(false)
		else:
			if cur_option_id == -1:
				check_conflicts = true
			else:
				checkboxes[[pick_id, cur_option_id]].set_enabled(false)
			checkboxes[[pick_id, option_id]].set_enabled(true)
			race_traits.set(pick_id, option_id + 1)
	else:
		var enabled = cur_option_id == -1
		race_traits.set(pick_id, int(enabled))
		checkboxes[[pick_id, 0]].set_enabled(enabled)
		check_conflicts = enabled

	if check_conflicts and G.conflict_map.has(pick_id):
		for pid in G.conflict_map[pick_id]:
			print("found conflict ", pick_id, " vs ", pid)
			if race_traits.get(pid) != 0:
				race_traits.set(pid, 0)
				var opts = G.config.picks[pid].options
				for oid in range(opts.size()):
					checkboxes[[pid, oid]].set_enabled(false)
	recalc_picks()

func _ready():
	if G.game == null:
		G.game = G.default_game()
		G.game.cur_player_id = G.game.add_player()
	init_scene(0)

func _on_back_pressed():
	Router.pop_scene()

func _on_accept_pressed():
	G.settings.last_race = U.clone(race_traits)
	G.game.get_current_player().race = $VBoxContainer/RaceName.text
	G.save_settings()
	Router.push_scene_choose_name()

func _on_clear_pressed():
	for cbi in checkboxes:
		checkboxes[cbi].set_enabled(false)
	race_traits = G.Race.new()
	for pid in U.obj_props(race_traits):
		var v = race_traits.get(pid)
		if v > 0:
			checkboxes[[pid, v - 1]].set_enabled(true)
	recalc_picks()
