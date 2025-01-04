extends Node

signal generate_universe_update(cur, tot)

const NOID = 0
const UINT32_MAX = 0xFFFFFFFF
const UINT32_MOD = UINT32_MAX + 1

enum Govt {
	FEUDAL = 0,
	FEUDAL2 = 1,
	DICTATORSHIP = 2,
	DICTATORSHIP2 = 3,
	DEMOCRACY = 4,
	DEMOCRACY2 = 5,
	UNIFICATION = 6,
	UNIFICATION2 = 7,
}

enum Minerals {
	UPOOR = 0,
	POOR = 1,
	ABUNDANT = 2,
	RICH = 3,
	URICH = 4,
}

enum Climate {
	TOXIC = 0,
	RADIATED = 1,
	BARREN = 2,
	DESERT = 3,
	TUNDRA = 4,
	OCEAN = 5,
	SWAMP = 6,
	ARID = 7,
	TERRAN = 8,
	GAIA = 9
}

enum PlanetSize {
	TINY = 0,
	SMALL = 1,
	AVERAGE = 2,
	LARGE = 3,
	HUGE = 4
}

enum Gravity {
	LOWG = 0,
	NORMALG = 1,
	HEAVYG = 2
}

enum PlanetKind {
	ASTEROID_BELT = 1,
	GAS_GIANT = 2,
	PLANET = 3,
	SPECIAL = 4, # unimplemented
}

enum PlanetSpecial {
	NONE = 0,
}

enum StarSpecial {
	NONE = 0,
	WORMHOLE = 1,
	SPACE_DEBRIS = 2,
	PIRATE_CACHE = 3,
	GOLD_DEPOSIT = 4,
	GEM_DEPOSIT = 5,
	NATIVES = 6,
	SPLINTER = 7,
	MAROONED_HERO = 8,
	MONSTER = 9,
	ARTIFACTS = 10,
	ORION = 11,
}

enum TechStatus {
	UNKNOWN = 0,
	KNOWN = 3,
}

enum Tech {
	ADVANCED_PLANNING = 3,
}

enum Building {
	ALIEN_CONTROL_CENTER = 1,
	ARMOR_BARRACKS = 2,
	ARTEMIS_SYSTEM_NET = 3,
	ASTRO_UNIVERSITY = 4,
	CAPITOL = 9,
	BIOSPHERES = 15,
	MARINE_BARRACKS = 22,
	FIGHTER_GARRISON = 47,
	ARTIFICIAL_PLANET = 48,
}

enum Civ {
	PRE_WARP,
	AVERAGE,
	POST_WARP,
	ADVANCED,
}

enum Age {
	YOUNG,
	AVERAGE,
	OLD,
}

class PopBonus:
	var biospheres: int = 2
	var advanced_planning: int = 5
	static var typeid = U.register_type(PopBonus, "PopBonus")
	
class RaceTraits:
	var growth: int = 0
	var farming: int = 0
	var industry: int = 0
	var science: int = 0
	var money: int = 0
	var defense: int = 0
	var attack: int = 0
	var ground: int = 0
	var spying: int = 0
	var government: int = 2
	var lowg_hw: int = 0
	var highg_hw: int = 0
	var aquatic: int = 0
	var subterranean: int = 0
	var large_hw: int = 0
	var rich_hw: int = 0
	var poor_hw: int = 0
	var arti_hw: int = 0
	var cybernetic: int = 0
	var lithovore: int = 0
	var repulsive: int = 0
	var charismatic: int = 0
	var uncreative: int = 0
	var creative: int = 0
	var tolerant: int = 0
	var fantastic_traders: int = 0
	var telepathic: int = 0
	var lucky: int = 0
	var omniscient: int = 0
	var stealthy_ship: int = 0
	var trans_dimensional: int = 0
	var warlord: int = 0
	static var typeid = U.register_type(RaceTraits, "RaceTraits")

class Race:
	var name: String = ""
	var traits: RaceTraits = RaceTraits.new()
	var is_native: bool = false
	var is_droid: bool = false
	static var typeid = U.register_type(Race, "Race")

enum GalaxySize {
	SMALL,
	MEDIUM,
	LARGE,
	CLUSTER,
	HUGE,
}

class GalaxyTraits:
	var n_stars = 20
	var size_x = 506
	var size_y = 400
	var sectors_x = 5
	var sectors_y = 4
	var cur_zoom = 0
	var cur_scale = 10
	var max_scale = 10
	static var typeid = U.register_type(GalaxyTraits, "GalaxyTraits")

class Settings:
	var difficulty: int = 0
	var galaxy_size: int = 2
	var galaxy_age: int = Age.AVERAGE
	var players: int = 6
	var tech_level: int = 0
	var tactical_combat: int = 1
	var antaran_attacks: int = 0
	var random_events: int = 1
	var last_race: Race = Race.new()
	static var typeid = U.register_type(Settings, "Settings")

class PickNum:
	var maximum_positive_picks: int = 10
	var maximum_negative_picks: int = -10
	var evolutionary_mutation_bonus: int = 4
	static var typeid = U.register_type(PickNum, "PickNum")

class NebulaTemplate:
	var image_id: String
	var size: Vector2i

class Nebula:
	var template: int
	var pos: Vector2i
	var flip: int # 0- 4

enum MonsterType {
	AMOEBA,
	CRYSTAL,
	DRAGON,
	EEL,
	HYDRA,
	GUARDIAN,
	ANTARAN,
}

class Config:
	var picks: Dictionary = {} # String -> Pick
	var gui_pick_groups: Array[PickGroup] = []
	var number_of_race_picks: PickNum = PickNum.new()
	var pick_conflicts: Array = [
		["lowg_hw", "highg_hw"],
		["rich_hw", "poor_hw"],
		["lithovore", "farming"],
		["lithovore", "cybernetic"],
		["creative", "uncreative"],
		["repulsive", "charismatic"],
	]
	var pick_conflicts_map: Dictionary = {}
	var standard_races: Array[Race] = []
	var star_class_chance: Array = [
		# color x age
		[20, 10, 5],
		[25, 15, 5],
		[10, 16, 30],
		[10, 16, 21],
		[32, 37, 30],
		[1, 2, 3],
		[2, 4, 6],
	]
	var class_to_num_satellites: Array = [
		# roll10 x color
		[0, 0, 1, 2, 0, 0],
		[1, 1, 2, 2, 1, 0],
		[1, 1, 2, 2, 1, 0],
		[2, 1, 2, 3, 1, 0],
		[3, 2, 3, 3, 2, 0],
		[3, 2, 3, 4, 2, 0],
		[4, 3, 4, 4, 2, 0],
		[4, 3, 4, 5, 3, 1],
		[5, 4, 5, 5, 3, 1],
		[5, 4, 5, 5, 4, 1],
	]
	var satellite_orbit_chance: Array = [
		[25, 20, 10],
		[18, 20, 22],
		[17, 20, 30],
		[15, 20, 33],
		[25, 20,  5],
	]
	var orbit_to_satellite_type: Array = [
		[1, 1, 1, 1, 1],
		[4, 1, 1, 1, 2],
		[3, 2, 1, 2, 2],
		[3, 3, 2, 2, 2],
		[3, 3, 2, 2, 2],
		[3, 3, 3, 3, 2],
		[3, 3, 3, 3, 3],
		[3, 3, 3, 3, 3],
		[3, 3, 3, 3, 3],
		[3, 3, 3, 3, 3],
	]
	var class_to_mineral: Array = [
		[2, 1, 1, 0, 0, 1],
		[2, 1, 1, 1, 0, 2],
		[2, 2, 1, 1, 1, 2],
		[2, 2, 2, 1, 1, 2],
		[3, 2, 2, 1, 1, 2],
		[3, 2, 2, 2, 1, 2],
		[3, 3, 2, 2, 2, 3],
		[3, 3, 3, 2, 2, 3],
		[4, 3, 3, 2, 2, 3],
		[4, 4, 4, 3, 2, 4],
	]
	var planet_size_to_gravity: Array = [
		[0, 0, 1, 1, 1],
		[0, 0, 0, 1, 1],
		[0, 1, 1, 1, 2],
		[1, 1, 1, 2, 2],
		[1, 1, 2, 2, 2],
	]
	var orbit_to_climate_group: Array = [
		[0, 0, 0, 0, 1],
		[0, 0, 1, 2, 3],
		[0, 1, 2, 2, 3],
		[1, 2, 2, 2, 3],
		[1, 2, 3, 3, 3],
		[0, 0, 1, 2, 3],
	]
	var climate_chance_young_avg_gal: Array = [
		[15, 15, 10, 20],
		[55, 50, 15,  0],
		[25, 25, 10, 70],
		[5,  10, 10,  0],
		[0,  5,  10,  8],
		[0,  0,  10,  2],
		[0,  0,  11,  0],
		[0,  0,  11,  0],
		[0,  0,  11,  0],
		[0,  0,  2,   0],
	]
	var climate_chance_old_gal: Array = [
		[15, 5 , 5, 20],
		[40, 30, 8, 0],
		[20, 20, 8, 50],
		[25, 25, 13, 0],
		[0,  20, 13, 30],
		[0,  0, 13, 0],
		[0,  0, 13, 0],
		[0,  0, 13, 0],
		[0,  0, 10, 0],
		[0,  0, 4, 0],
	]
	var planet_size_table: Array = [1, 3, 7, 9, 10]
	var galaxy_traits: Dictionary = {}
	var star_special_chance = 64
	var planet_special_chance = [64, 5, 3, 1, 2, 1, 9, 4, 3, 0, 5]
	var generate_orion = true
	var force_n_monsters = -1
	var nebula_templates: Array = []
	var max_pop: Array = [5, 10, 15, 20, 25] # per planet size
	var climate_pop: Array = [25, 25, 25, 25, 25, 25, 40, 60, 80, 100] # per climate
	var pop_bonus: PopBonus = PopBonus.new()
	var system_monster_design: Dictionary = {}
	var wandering_monster_design: Dictionary = {}
	var antaran_design: Dictionary = {}
	var monster_name: Array = ["Space Amoeba", "Space Crystal", "Space Dragon", "Space Eel", "Space Hydra", "Guardian", "Antaran Fleet"]
	var need_orion: bool = false
	static var typeid = U.register_type(Config, "Config", {
		picks = Pick,
		gui_pick_groups = PickGroup,
		standard_races = Race,
		galaxy_traits = GalaxyTraits,
		nebula_templates = NebulaTemplate,
		antaran_design = ShipDesign, # off SizeClass
		system_monster_design = ShipDesign, # off MonsterType
		wandering_monster_design = ShipDesign, # off MonsterType
	})

func load_settings():
	var tmp = Settings.new()
	var file = FileAccess.open(settings_file, FileAccess.READ)
	if file != null:
		U.obj_load(tmp, file.get_var())
		if tmp.last_race.traits.government == 0: # FIXME what?
			tmp.last_race.traits.government = 2
	settings_ = tmp

func save_settings():
	FileAccess.open(settings_file, FileAccess.WRITE).store_var(U.obj_save(settings_))

func save_file_name(slot):
	return "saves/save%s.gam" % slot

func save_game(slot = 10):
	print("save_game ", slot)
	game.print_stats()
	FileAccess.open(save_file_name(slot), FileAccess.WRITE) \
		.store_var(U.obj_save(game))

func load_game(slot = 10) -> bool:
	var tmp = default_game()
	var file = FileAccess.open(save_file_name(slot), FileAccess.READ)
	if not file:
		return false
	U.obj_load(tmp, file.get_var(), true)
	game = tmp
	game.print_stats()
	return true

func save_exists(slot = 10):
	var file = FileAccess.open(save_file_name(slot), FileAccess.READ)
	if not file:
		return false
	file.close()
	return true

func get_setting(setting_name):
	return U.obj_prop_get(settings_, setting_name)

func set_setting(setting_name, val):
	U.obj_prop_set(settings_, setting_name, val)

# represents a single option in a group, e.g. food options are -0.5, +1 and +2
class PickOption:
	var label: String
	var cost: int
	var bonus: float
	static var typeid = U.register_type(PickOption, "PickOption")
	func _init(_label: String = "", _cost: int = 0, _bonus: float = 0):
		label = _label
		cost = _cost
		bonus = _bonus

class Pick:
	var required: bool = false # specifically for government, one always has to be chosen
	var options: Array[PickOption] = []
	static var typeid = U.register_type(Pick, "Pick", {options = PickOption})

class PickOptionRef:
	var pick_id: String
	var option_id: int # 0-based, index inside pick
	static var typeid = U.register_type(PickOptionRef, "PickOptionRef")
	func _init(_pick_id: String = "", _option_id: int = 0):
		pick_id = _pick_id
		option_id = _option_id

class PickGroup:
	var label: String
	var option_refs: Array[PickOptionRef] = []
	static var typeid = U.register_type(PickGroup, "PickGroup", {option_refs = PickOptionRef})
	func _init(_label: String = ""):
		label = _label

class Player:
	var race: int = NOID
	var is_human: bool = false
	var picture: int = 0
	var name: String = ""
	var banner: int = 0
	var tech: Dictionary = {}
	var known_stars: Dictionary = {} # si -> date
	static var typeid = U.register_type(Player, "Player")

class Star:
	var name: String = ""
	var pos: Vector2i = Vector2i(0, 0)
	var picture: int = 0
	var color: int = 0
	var orbits: Array[int] = U.array(5, NOID)
	var wormhole: int = NOID
	var special: int = StarSpecial.NONE
	static var typeid = U.register_type(Star, "Star")

class Planet:
	var star: int = NOID
	var size: int = PlanetSize.AVERAGE
	var kind: int = PlanetKind.PLANET
	var orbit: int = 0
	var climate: int = Climate.TERRAN
	var minerals: int = Minerals.ABUNDANT
	var gravity: int = Gravity.NORMALG
	var special: int = StarSpecial.NONE
	var colony: int = NOID
	static var typeid = U.register_type(Planet, "Planet")

enum Job {
	FARMER,
	WORKER,
	SCIENTIST,
}

class Pop:
	var race: int = NOID # race id
	var job: int = 0
	var prisoner: int = 0
	static var typeid = U.register_type(Pop, "Pop")

class Colony:
	var player: int = NOID
	var planet: int = NOID
	var pop: Array[Pop] = []
	var buildings: Dictionary = {} # int as building id?
	var climate: int = 0
	var is_outpost: int = 0
	static var typeid = U.register_type(Colony, "Colony", {pop = Pop})

enum Mod {
	HV,
	AP,
	NR,
}

class WeaponSlot:
	var weapon: int = 0
	var count: int = 0
	var mods: Array = [] # Mod
	static var typeid = U.register_type(WeaponSlot, "WeaponSlot")

enum SizeClass {
	FRIGATE = 0,
	DESTROYER = 1,
	CRUISER = 2,
	BATTLESHIP = 3,
	TITAN = 4,
	DOOM_STAR = 5,
	
	STAR_BASE = 6,
	BATTLESTATION = 7,
	STAR_FORTRESS = 8,
}

class ShipDesign:
	var size_class: int = 0
	var weapon_slots: Array[WeaponSlot] = []
	var specials: Dictionary = {} # int special ID?
	static var typeid = U.register_type(ShipDesign, "ShipDesign", {
		weapon_slots = WeaponSlot
	})

class Ship:
	var player: int = NOID
	var monster_kind: int = 0
	var design: ShipDesign = ShipDesign.new()
	var name: String
	var pos: Vector2i = Vector2i(0, 0)
	var at_star: int = NOID
	static var typeid = U.register_type(Ship, "Ship")

enum LeaderStatus { LIMBO, MAROONED, FOR_HIRE, HIRED, DEAD }
enum LeaderType { FLEET, COLONY }
enum StarColor { BLUE, WHITE, YELLOW, ORANGE, RED, BROWN, BH }

class Leader:
	var name: String
	var title: String
	var description: String
	var skills: Dictionary = {}
	var xp: int = 0
	var type: int = LeaderType.FLEET
	var status: int = LeaderStatus.LIMBO
	var cur_player: int = NOID
	var location: int = NOID
	static var typeid = U.register_type(ShipDesign, "ShipDesign")

func _ready():
	U.init_registered_types()
	load_settings()
	print("Globals ready")

var stop_generate_mt = false

func report_progress(cur, tot) -> bool:
	if stop_generate_mt:
		stop_generate_mt = false
		return true
	call_deferred("emit_signal", "generate_universe_update", cur,  tot)
	return false

func generate_universe_ext():
	if game.init_new_game(report_progress):
		return
	save_game()
	report_progress(1, 1)

func generate_universe_mt():
	stop_generate_mt = false
	WorkerThreadPool.add_task(generate_universe_ext)

func generate_universe_mt_cancel():
	stop_generate_mt = true

enum {
	PARSEC_UNITS = 30,
	MAX_BH_DISTANCE_SQ = (PARSEC_UNITS * 3 / 2) ** 2,
}

static var settings_: Settings
static var game: Game

const settings_file = "user://settings.dat"

func standard_races() -> Array[Race]:
	var race_maps = [
		{ name = "Alkari", government = 2, defense = 3, arti_hw = 1 },
		{ name = "Bulrathi", government = 2, attack = 2, ground = 2, highg_hw = 1 },
		{ name = "Darlok", government = 2, spying = 3, stealthy_ships = 1 },
		{ name = "Elerian", government = 1, defense = 1, attack = 1, telepathic = 1, omniscient = 1 },
		{ name = "Gnolam", government = 2, money = 2, lowg_hw = 1, fantastic_traders = 1, lucky = 1 },
		{ name = "Human", government = 3, charismatic = 1 },
		{ name = "Klackon", government = 4, farming = 2, industry = 2, large_hw = 1, uncreative = 1 },
		{ name = "Meklar", government = 2, industry = 3, cybernetic = 1 },
		{ name = "Mrrshan", government = 2, attack = 3, rich_hw = 1, warlord = 1 },
		{ name = "Psilon", government = 2, research = 3, lowg_hw = 1, creative = 1 },
		{ name = "Sakkra", government = 1, growth = 3, farming = 2, spying = 1, subterranean = 1, large_hw = 1 },
		{ name = "Silicoid", government = 2, growth = 1, lithovore = 1, repulsive = 1, tolerant = 1 },
		{ name = "Trilarian", government = 2, aquatic = 1, trans_dimensional = 1 },
	]
	var ret: Array[Race] = []
	for race_map in race_maps:
		var r: Race = Race.new()
		r.name = race_map["name"]
		for pick in race_map:
			if pick != "name":
				r.traits.set(pick, int(race_map[pick]))
		ret.append(r)
	return ret

func init_pick_info(c: Config):
	var misc = false
	# key-label-value string is either:
	#	"warlord Warlord 4" -- single option pick
	#	"growth Population -50%_Growth -4 +50%_Growth 3 +100%_Growth 6" -- multiple options pick
	const raw_pick_info = [
		"growth Population -50%_Growth -4 +50%_Growth 3 +100%_Growth 6",
		"farming Farming -0.5_Food -3 +1_Food 4 +2_Food 7",
		"industry Industry -1_Production -3 +1_Production 3 +2_Production 6",
		"science Science -1_Research -3 +1_Research 3 +2_Research 6",
		"money Money -0.5_BC -4 +0.5_BC 5 +1_BC 8",
		"defense Ship_Defense -20_Defense -2 +25_Defense 3 +50_Defense 7",
		"attack Ship_Attack -20_Attack -2 +20_Attack 2 +50_Attack 4",
		"ground Ground_Combat -10_Ground -2 +10_Ground 2 +20_Ground 4",
		"spying Spying -10_Spying -3 +10_Spying 3 +20_Spying 6",
		"government Government Feudal -4 Dictatorship 0 Democracy 7 Unification 6",
		"lowg_hw Low-G_World -5",
		"highg_hw High-G_World 6",
		"aquatic Aquatic 5",
		"subterranean Subterranean 6",
		"large_hw Large_Home_World 1",
		"rich_hw Rich_Home_World 2",
		"poor_hw Poor_Home_World -1",
		"arti_hw Artifact_World 3",
		"cybernetic Cybernetic 4",
		"lithovore Lithovore 10",
		"repulsive Repulsive -6",
		"charismatic Charismatic 3",
		"uncreative Uncreative -4",
		"creative Creative 8",
		"tolerant Tolerant 10",
		"fantastic_traders Fantastic_Traders 4",
		"telepathic Telepathic 6",
		"lucky Lucky 3",
		"omniscient Omniscient 3",
		"stealthy_ship Stealthy_Ship 4",
		"trans_dimensional Trans_Dimensional 5",
		"warlord Warlord 4",
	]
	for raw in raw_pick_info:
		var klv = raw.split(" ")
		for i in range(1, klv.size()):
			klv[i] = klv[i].replace("_", " ")
		var pick_id = klv[0]
		var options: Array[PickOption] = []
		var pick: Pick = Pick.new()
		c.picks[pick_id] = pick
		pick.required = pick_id == "government"
		if klv.size() == 3: # single-option pick
			if not misc:
				misc = true
				c.gui_pick_groups.append(PickGroup.new("Special Abilities"))
			var label = klv[1]
			pick.options.push_back(PickOption.new(label, int(klv[2])))
			c.gui_pick_groups[-1].option_refs.append(PickOptionRef.new(pick_id, 0))
		else:
			c.gui_pick_groups.append(PickGroup.new(klv[1]))
			for i in range(2, klv.size(), 2):
				var opt_label = klv[i]
				var cost = int(klv[i + 1])
				var bonus = float(opt_label)
				pick.options.append(PickOption.new(opt_label, cost, bonus))
				c.gui_pick_groups[-1].option_refs.append(PickOptionRef.new(pick_id, i / 2 - 1))

# { ... lithovore = { farming = 1, cybernetic = 1 } }
func init_pick_conflicts_map(conf: Config):
	var conflicts = {} # lithovore = { farming = 1, cybernetic = 1 }
	for c in conf.pick_conflicts:
		for i in range(0, 2):
			var a = c[i]
			var b = c[1 - i]
			if not conflicts.has(a):
				conflicts[a] = {}
			conflicts[a][b] = 1;
	conf.pick_conflicts_map = conflicts

func default_config() -> Config:
	var c = Config.new()
	c.galaxy_traits = {
		GalaxySize.SMALL:   U.obj_fill(GalaxyTraits.new(), [20,  506,  400, 5, 4, 0, 10, 10]),
		GalaxySize.MEDIUM:  U.obj_fill(GalaxyTraits.new(), [36,  759,  600, 6, 6, 1, 15, 15]),
		GalaxySize.LARGE:   U.obj_fill(GalaxyTraits.new(), [54, 1012,  800, 9, 6, 2, 20, 20]),
		GalaxySize.CLUSTER: U.obj_fill(GalaxyTraits.new(), [70, 1011,  800, 9, 6, 3, 15, 20]),
		GalaxySize.HUGE:    U.obj_fill(GalaxyTraits.new(), [71, 1518, 1200, 9, 8, 3, 30, 30]),
	}
	c.standard_races = standard_races()
	init_pick_info(c)
	init_pick_conflicts_map(c)
	return c

class Game:
	var settings: Settings = Settings.new()
	var config: Config = Config.new()
	var races: Dictionary = {}
	var players: Dictionary = {}
	var stars: Dictionary = {}
	var planets: Dictionary = {}
	var ships: Dictionary = {}
	var colonies: Dictionary = {}
	var leaders: Dictionary = {}
	var cur_player_id: int = NOID
	var last_id: int = NOID + 1
	var rng_seed: int = 0
	var size: Vector2i = Vector2i.ZERO
	var nebulas: Array[Nebula] = []
	var stardate: int
	static var typeid = U.register_type(Game, "Game", {
		races = Race,
		players = Player,
		stars = Star,
		planets = Planet,
		ships = Ship,
		colonies = Colony,
		nebulas = Nebula,
	})

	func gen_id() -> int:
		# last_id = last_id * 1361 % 9223372036854775783 
		last_id += 1
		if last_id <= 0:
			last_id = 1
		return last_id

	func add_player() -> int:
		var id = gen_id()
		var player = Player.new()
		players[id] = player
		player.race = add_race()
		return id
		
	func add_star() -> int:
		var id = gen_id();
		stars[id] = Star.new()
		return id

	func add_planet() -> int:
		var id = gen_id();
		planets[id] = Planet.new()
		return id

	func add_colony() -> int:
		var id = gen_id();
		colonies[id] = Colony.new()
		return id

	func add_ship() -> int:
		var id = gen_id();
		ships[id] = Ship.new()
		return id

	func add_race(r = null) -> int:
		var id = gen_id();
		races[id] = Race.new() if r == null else r
		return id

	class MapgenCtx:
		var n_marooned_heroes = 0
		var max_marooned_heroes = 0
		var n_monsters = 0
		var n_wormholes = 0
		var max_wormholes = 0
		var steps = 0
		var progress
		func do_step():
			steps += 1
			if progress:
				progress.call(steps, steps + 100)

	func get_current_player() -> Player:
		return players[cur_player_id]

	func random(n: int) -> int:
		if n <= 0:
			return 1
		var step = UINT32_MAX / n
		var max_seed = step * n
		while (true):
			rng_seed = (1103515245 * rng_seed + 12345) % UINT32_MOD
			if rng_seed < max_seed:
				return rng_seed / step + 1
		return 1 # never happens

	func weighted_roll(ws):
		var sum = 0
		for v in ws:
			sum += v
		if sum == 0:
			return -1
		var r = random(sum)
		for i in ws.size():
			if r <= ws[i]:
				return i
			r -= ws[i]
		# Normally this should never happen, unless some weights are negative (bugs).
		# In the original game it would result in reading beyond array boundary,
		# which results in undefined behavior and can't be reasonably emulated.
		assert(0, "bad weights: %s" % ws)
		return -1

	func random_vec(v: Vector2i) -> Vector2i:
		return Vector2i(random(v[0]), random(v[1]))

	func size_climate_race_pop_limit(psize: int, climate: int, rid: int) -> int:
		var traits = races[rid].traits
		if traits.aquatic:
			match climate:
				Climate.SWAMP:
					climate = Climate.TERRAN
				Climate.OCEAN, Climate.TERRAN:
					climate = Climate.GAIA
				Climate.TUNDRA:
					climate = Climate.TERRAN
		var base = config.max_pop[psize]
		var ratio = min(25 * traits.tolerant + config.climate_pop[climate], 100)
		var pop = (base * ratio + 50) / 100
		if traits.subterranean:
			pop += 2 * (psize + 1)
		return pop

	func colony_race_pop_limit(cid: int, rid: int) -> int:
		var col: Colony = colonies[cid]
		var player: Player = players[col.player]
		var psize = planets[col.planet].size
		var pop = size_climate_race_pop_limit(psize, col.climate, rid)
		if player.tech[Tech.ADVANCED_PLANNING] == TechStatus.KNOWN:
			pop += config.pop_bonus.advanced_planning
		if col.buildings[Building.BIOSPHERES]:
			pop += config.pop_bonus.biospheres
		return pop

	func planet_player_pop_limit(pid: int, plid: int) -> int:
		var planet = planets[pid]
		var player = players[plid]
		var cid = planet.colony
		var colony: Colony
		if cid != NOID:
			colony = colonies[cid]
		if not colony or colony.is_outpost:
			var pop = size_climate_race_pop_limit(planet.size, planet.climate, player.rid)
			if player.tech[Tech.ADVANCED_PLANNING] == TechStatus.KNOWN:
				pop += config.pop_bonus.advanced_planning
			return pop

		if colony.pop.is_empty():
			return colony_race_pop_limit(cid, player.race)

		var processed_races = {}
		var max_pop = 0
		for pop in colony.pop:
			if not pop.race in processed_races:
				processed_races[pop.race] = 1
				max_pop = max(max_pop, colony_race_pop_limit(cid, pop.race))
		return max_pop

	func generate_spectral_class() -> int:
		var ws = []
		ws.resize(7)
		for i in 7:
			ws[i] = config.star_class_chance[i][settings.galaxy_age]
		return weighted_roll(ws)

	func generate_number_of_satellites(color: int) -> int:
		var r = random(10) - 1
		if color == StarColor.BH:
			return 0 # original behavior is to always roll even for BH!
		return config.class_to_num_satellites[r][color]

	func generate_size() -> PlanetSize:
		var r = random(10)
		var cha = config.planet_special_chance
		for i in range(cha.size()):
			if r < cha[i]:
				return i
		return PlanetSize.AVERAGE

	func generate_mineral_class(color: int) -> Minerals:
		return config.class_to_mineral[random(10) - 1][color]

	func generate_climate(color: StarColor, oi: int, make_food_planet: bool = false) -> Climate:
		var group = config.orbit_to_climate_group[color][oi]
		var weights = U.array(10)
		for i in range(10):
			match settings.galaxy_age:
				Age.YOUNG, Age.AVERAGE:
					weights[i] = config.climate_chance_young_avg_gal[i][group]
				Age.OLD:
					weights[i] = config.climate_chance_old_gal[i][group]
		if make_food_planet:
			pass # TODO
		return weighted_roll(weights)

	func generate_gravity(planet: Planet) -> Gravity:
		return config.planet_size_to_gravity[planet.minerals][planet.size]

	func planet_generation(si: int) -> bool:
		var oi = generate_orbit(si)
		if oi == -1:
			return false
		var kind = generate_satellite_type(si, oi)
		var star: Star = stars[si]
		if kind in [PlanetKind.PLANET, PlanetKind.ASTEROID_BELT, PlanetKind.GAS_GIANT]:
			var pi = add_planet()
			var planet: Planet = planets[pi]
			star.orbits[oi] = pi
			planet.star = si
			planet.orbit = oi
			planet.colony = NOID
			planet.kind = kind
			planet.size = generate_size()
			planet.minerals = generate_mineral_class(star.color)
			planet.gravity = generate_gravity(planet)
			planet.climate = generate_climate(star.color, oi)
			# TODO
			# planet.picture = random(3) - 1
			# planet.max_farms
			# planet.food_base  = generate food per farmer
		return true

	func generate_satellite_type(si: int, oi: int) -> PlanetKind:
		while true:
			var r = random(10) - 1
			var type = config.orbit_to_satellite_type[r][oi]
			if r == PlanetKind.SPECIAL:
				type = PlanetKind.ASTEROID_BELT # unimplemented
			if type != PlanetKind.GAS_GIANT or oi: # no giants in closest orbit
				return type
		return PlanetKind.ASTEROID_BELT # to shut godot up

	func generate_orbit(sid: int) -> int:
		# TODO
		var w = [0, 0, 0, 0, 0]
		var sum = 0
		var orbits = stars[sid].orbits
		for i in 5:
			if orbits[i] == NOID:
				w[i] = config.satellite_orbit_chance[i][settings.galaxy_age]
				sum += w[i]
		if sum == 0:
			return -1
		return weighted_roll(w)


	func init_new_game(prog):
		var ctx = MapgenCtx.new()
		ctx.max_wormholes = 4 * (settings.galaxy_size + 1)
		ctx.max_marooned_heroes = settings.galaxy_size + 2
		ctx.progress = prog
		universe_generation(ctx)
		generate_home_worlds_stub()
		name_stars()
		# enforce_planet_max(250)
		# if settings.civ_level == Civ.ADVANCED:
			# advanced_civilization_colonies()
			# assign_advanced_civilization_ships()
		make_system_monsters(ctx)
		make_system_monsters_into_ships()
		generate_wormhole_links()
		# if settings.civ_level == Civ.ADVANCED:
			# allocate_adv_civ_officers()
		assign_marooned_heroes()
		twiddle_initial_homeworlds()
		update_data()

	func name_stars():
		var vov = [ "a", "i", "u", "e", "o"]
		var cons = [ "k", "r", "m", "n", "b", "t", "sh", "z"]
		var syllables = []
		for c in cons:
			for v in vov:
				syllables.append(c + v)
		var names = { "": 1 }
		for si in stars:
			var name = ""
			while name in names:
				name = generate_random_name(syllables, [1, 8, 4])
			stars[si].name = name
			names[name] = 1

	func generate_random_name(syllables: Array, lengths: Array) -> String:
		var name_length = weighted_roll(lengths) + 1
		var name = ""
		for n in range(name_length):
			name += syllables[randi() % syllables.size()]
		return name.capitalize()

	func star_in_nebula_n(si: int, n: Nebula):
		return is_point_in_box(stars[si].pos, n.pos, nebula_size(n))

	func star_in_nebula(si: int):
		for n in nebulas:
			star_in_nebula_n(si, n)

	func star_xy_valid(si: int) -> bool:
		return true # TODO
		var box = Vector2i(20, 20) # TODO: 50, 20 originally
		var s1: Star = stars[si]
		for si2 in stars:
			if si2 == si:
				break
			var s2: Star = stars[si2]
			var d = (s1.pos - s2.pos).abs()
			var box_clash = d[0] < box[0] || d[1] < box[1]
			var clash_800 = d.length_squared() <= 800 # FIXME 800
			if box_clash or clash_800:
				# print("clash ", box_clash, " ", clash_800, " ", s1.pos, " ", s2.pos, " ", d)
				return false
		if is_bh(s1) and star_in_nebula(si):
			return false
		return true

	func set_star_xys(init: bool):
		var gt = config.galaxy_traits[settings.galaxy_size]
		var step_x = gt.size_x / gt.sectors_x
		var step_y = gt.size_y / gt.sectors_y
		var gal_box = Vector2i(20, 20)
		var sn = 0
		for si in stars:
			var star: Star = stars[si]
			if init:
				star.color = generate_spectral_class()
			var sector_off_x = sn % gt.sectors_x * step_x
			var sector_off_y = sn * step_y / gt.sectors_x
			var x
			var y
			while true:
				x = (random(3 * step_x) + sector_off_x) % gt.size_x
				if x >= gal_box[0] && x + gal_box[0] <= gt.size_x:
					break
			while true:
				y = (random(3 * step_y) + sector_off_y) % gt.size_y
				if y >= gal_box[1] && y + gal_box[1] <= gt.size_y:
					break
			star.pos = Vector2i(x, y)
			# print("rpos ", star.pos, " gt(", gt.size_x, ",", gt.size_y, ")")
			var retries = 0
			while (not star_xy_valid(si)):
				star.pos[0] = random(gt.size_x - 2 * gal_box[0]) + gal_box[0]
				star.pos[1] = random(gt.size_y - 2 * gal_box[1]) + gal_box[1]
				retries += 1
				if retries >= 150:
					return
				# assert(retries <= 150, "loop in set_star_xys")
			sn += 1

	func nebula_size(nebula: Nebula, margin: Vector2i = Vector2i.ZERO) -> Vector2i:
		return config.nebulas[nebula.template].size + margin

	func nebula_valid(nebula1: Nebula, margin) -> bool:
		var sz1 = nebula_size(nebula1, margin)
		for nebula2 in nebulas:
			if boxes_collide(nebula1.pos, sz1, nebula2.pos, nebula_size(nebula2, margin)):
				return false
		return true

	func generate_nebulas():
		# TODO understand original algorithm	
		if not config.nebula_templates:
			return
		var num_nebulas = 0
		match settings.galaxy_size:
			GalaxySize.SMALL:
				num_nebulas = random(2) - 1
			GalaxySize.MEDIUM:
				num_nebulas = random(2)
			GalaxySize.LARGE, GalaxySize.CLUSTER:
				num_nebulas = random(3)
			GalaxySize.HUGE:
				num_nebulas = random(3) + 1
		var n_weights = config.nebula_templates.size()
		var weights = U.array(n_weights, 1)
		var gt: GalaxyTraits = config.galaxy_traits[settings.galaxy_size]
		var takes = 0
		while nebulas.size() < num_nebulas and takes < 1000:
			takes += 1
			if n_weights == 0:
				n_weights = config.nebula_templates.size()
				weights = U.array(n_weights, 1)
			var r = weighted_roll(weights)
			var nebula = Nebula.new()
			var nebula_template = config.nebulas[r]
			nebula.model = r
			nebula.flip = random(4)
			var sz = nebula_template.size
			var margin = Vector2i(10, 10)
			var box = Vector2i(gt.size_x, gt.size_y) - margin - sz
			if box[0] <= 0 || box[1] <= 0:
				continue
			var collision
			for j in 100:
				var rx = random(box[0]) - 1
				var ry = random(box[1]) - 1
				nebula.pos = Vector2i(rx, ry) + margin
				if nebula_valid(nebula, margin):
					nebulas.push_back(nebula)
					break

	func generate_star_special(si: int, mapgen_ctx: MapgenCtx):
		var has_nospec_planet = false
		var nospec_weights = U.array(5, 0)
		var has_farmable_planet = false
		var farmable_weights = U.array(5, 0)
		var has_farmable_medium = false
		var farmable_medium_weights = U.array(5, 0)
		var star: Star = stars[si]
		for oi in star.orbits.size():
			var pi = star.orbits[oi]
			if pi == NOID:
				continue
			var p: Planet = planets[pi]
			if p.kind == PlanetKind.PLANET and p.special == PlanetSpecial.NONE:
				has_nospec_planet = true
				nospec_weights[oi] = 1
				if p.climate in [Climate.DESERT, Climate.ARID, Climate.TUNDRA,
					Climate.OCEAN, Climate.SWAMP, Climate.TERRAN, Climate.GAIA]:
					has_farmable_planet = true
					farmable_weights[oi] = 1
					if p.size >= PlanetSize.AVERAGE:
						has_farmable_medium = true
						farmable_medium_weights[oi] = 1
		var special_rolls = config.planet_special_chance.duplicate()
		if !has_farmable_planet:
			special_rolls[StarSpecial.ARTIFACTS] = 0
		if !has_farmable_medium:
			special_rolls[StarSpecial.NATIVES] = 0
			special_rolls[StarSpecial.SPLINTER] = 0
		if mapgen_ctx.n_marooned_heroes >= mapgen_ctx.max_marooned_heroes:
			special_rolls[StarSpecial.MAROONED_HERO] = 0
		if mapgen_ctx.n_wormholes >= mapgen_ctx.max_wormholes:
			special_rolls[StarSpecial.WORMHOLE] = 0
		if mapgen_ctx.n_monsters == config.force_n_monsters:
			special_rolls[StarSpecial.MONSTER] = 0
		var spec = weighted_roll(special_rolls)
		star.special = spec
		var spec_oid = -1
		match spec:
			StarSpecial.MAROONED_HERO:
				mapgen_ctx.n_marooned_heroes += 1
			StarSpecial.MONSTER:
				mapgen_ctx.n_monsters += 1
			StarSpecial.WORMHOLE:
				mapgen_ctx.n_wormholes += 1
			StarSpecial.GOLD_DEPOSIT, StarSpecial.GEM_DEPOSIT:
				spec_oid = weighted_roll(nospec_weights)
			StarSpecial.ARTIFACTS:
				spec_oid = weighted_roll(farmable_weights)
			StarSpecial.NATIVES, StarSpecial.SPLINTER:
				spec_oid = weighted_roll(farmable_medium_weights)
		if spec_oid != -1:
			planets[star.orbits[spec_oid]].special = spec

	func universe_generation(ctx: MapgenCtx):
		var gt: GalaxyTraits = config.galaxy_traits[settings.galaxy_size]
		size = Vector2i(gt.size_x, gt.size_y)

		generate_nebulas()
		for i in gt.n_stars:
			var si = add_star()
			if i == 0 and config.need_orion:
				stars[si].special = StarSpecial.ORION

		set_star_xys(true)
		for si in stars:
			var star: Star = stars[si]
			# star.size = weighted_roll([3, 4, 3])
			star.picture = random(3) - 1
			if star.color != StarColor.BH:
				var sats = generate_number_of_satellites(star.color)
				for i in sats:
					if not planet_generation(si):
						break
				if star.special == StarSpecial.NONE:
					generate_star_special(si, ctx)
			star.wormhole = NOID
			ctx.do_step()

		for i in 100:
			ctx.do_step()
			if map_is_connected():
				return
			set_star_xys(false)

	# check map is connected in 8-parsec strides
	func map_is_connected() -> bool:
		return false
		var bhs = []
		var num_comps = 0
		for s in stars:
			if stars[s].color == StarColor.BH:
				bhs.push_back(stars[s].pos)
			else:
				num_comps += 1
		const max_dist_sq = (PARSEC_UNITS * 8) ** 2
		var links = {}
		for ai in stars:
			var a: Star = stars[ai]
			if a.color == StarColor.BH:
				continue
			for bi in stars:
				if bi == ai:
					break
				var b: Star = stars[bi]
				if b.color == StarColor.BH:
					continue
				if idistance_sq(a.pos, b.pos) > max_dist_sq:
					continue
				if path_blocked_by_bhs(a.pos, b.pos, bhs):
					continue
				var ar = link_root(links, ai)
				var br = link_root(links, bi)
				if ar != br:
					num_comps -= 1
				link_root(links, ai, br)
				link_root(links, bi, br)
		return num_comps == 1

	func is_point_in_box(pt: Vector2i, boxpt: Vector2i, boxsz: Vector2i):
		for c in 2:
			if pt[c] < boxpt[c] or pt[c] > boxpt[c] + boxsz[c]:
				return false
		return true

	func boxes_collide(a: Vector2i, asz: Vector2i, b: Vector2i, bsz: Vector2i) -> bool:
		for k in 2:
			if a[k] > b[k] + bsz[k] or b[k] > a[k] + asz[k]:
				return false
		return true

	func link_root(links: Dictionary, id: int, rewrite_links: int = NOID):
		while true:
			var next = links.get(id)
			if rewrite_links != NOID:
				links[id] = rewrite_links
			if next == null or next == id:
				return id
			id = next

	func path_blocked_by_bh(a: Vector2i, b: Vector2i, bh: Vector2i) -> bool:
		var seg: Vector2i = b - a
		var pt = bh - a
		var seg_len_sq = seg.length_squared()
		var par = 0.
		if seg_len_sq != 0:
			par = clamp(Vector2(seg).dot(Vector2(pt)) / seg_len_sq, 0., 1.)
		return (Vector2(seg) * par - Vector2(pt)).length_squared() <= MAX_BH_DISTANCE_SQ

	func path_blocked_by_bhs(a: Vector2i, b: Vector2i, bhs: Array) -> bool:
		for bh in bhs:
			if path_blocked_by_bh(a, b, bh):
				return true
		return false

	func is_bh(s: Star) -> bool:
		return s.color == StarColor.BH

	func create_home_world(s: Star, pli: int):
		var oi = random(5) - 1
		var pi = s.orbits[oi]
		var pl: Player = players[pli]
		var r: Race = races[pl.race]
		if pi == NOID:
			pi = add_planet()
			s.orbits[oi] = pi
		var p: Planet = planets[pi]

		p.climate = Climate.TERRAN
		if r.traits.aquatic:
			p.climate = Climate.OCEAN
		
		p.size = PlanetSize.AVERAGE
		if r.traits.large_hw:
			p.size = PlanetSize.LARGE

		p.minerals = Minerals.ABUNDANT
		if r.traits.rich_hw:
			p.minerals = Minerals.RICH
		elif r.traits.poor_hw:
			p.minerals = Minerals.POOR
		
		p.gravity = Gravity.NORMALG
		if r.traits.lowg_hw:
			p.gravity = Gravity.LOWG
		elif r.traits.highg_hw:
			p.gravity = Gravity.HEAVYG

		p.special = StarSpecial.NONE
		if r.traits.arti_hw:
			p.special = StarSpecial.ARTIFACTS

		var ci = add_colony()
		p.colony = ci
		var c: Colony = colonies[ci]
		c.player = pli
		c.planet = pi
		for i in 6:
			var pop = Pop.new()
			pop.job = Job.WORKER if i < 3 else Job.FARMER
			pop.race = pl.race
			c.pop.push_back(pop)

		if not r.traits.government in [Govt.UNIFICATION, Govt.UNIFICATION2]:
			c.buildings[Building.CAPITOL] = 1
		c.buildings[Building.MARINE_BARRACKS] = 1

	func generate_home_worlds_stub():
		# TODO actual logic
		var good = []
		for si in stars:
			var s = stars[si]
			if not is_bh(s) and s.special != StarSpecial.ORION:
				good.append(s)
		for pli in players:
			assert(not good.is_empty(), "not enough stars for placing homeworlds")
			var r = random(good.size()) - 1
			var s = good[r]
			good.remove_at(r)
			create_home_world(s, pli)

	func make_system_monsters(mapgen_ctx: MapgenCtx):
		if config.force_n_monsters < 0:
			return
		if config.force_n_monsters >= mapgen_ctx.n_monsters:
			return		
		var star_has_colony = {}
		for ci in colonies:
			var c: Colony = colonies[ci]
			star_has_colony[planets[c.planet].star] = 1
		var suitable_stars = []
		var n_monsters = 0
		for si in stars:
			if star_has_colony[si]:
				continue
			var s: Star = stars[si]
			if s.special == StarSpecial.MONSTER:
				n_monsters += 1
				continue
			if is_bh(s):
				continue
			if s.special == StarSpecial.ORION:
				continue
			suitable_stars.append(si)
		while mapgen_ctx.n_monsters < config.force_n_monsters and suitable_stars:
			var r = random(suitable_stars.size()) - 1
			var s = stars[suitable_stars[r]]
			s.special = StarSpecial.MONSTER
			suitable_stars[r] = suitable_stars[-1]
			suitable_stars.pop_back()
			mapgen_ctx.n_monsters += 1

	func make_system_monsters_into_ships():
		for si in stars:
			var s: Star = stars[si]
			if s.special == StarSpecial.MONSTER:
				var kind = random(MonsterType.HYDRA) - 1
				var shid = add_ship()
				var ship: Ship = ships[shid]
				ship.design = config.system_monster_design.get(kind).duplicate()
				ship.player = NOID
				ship.monster_kind = kind
				ship.name = config.monster_name[kind]
				ship.pos = s.pos
				ship.at_star = si

	func link_stars(ai: int, bi: int):
		stars[ai].wormhole = bi
		stars[bi].wormhole = ai	

	func generate_wormhole_links():
		var ii = []
		for si in stars:
			if stars[si].special == StarSpecial.WORMHOLE:
				ii.push_back(si)
		while ii.size() >= 2:
			var r = random(ii.size() - 1) - 1
			link_stars(ii[-1], ii[r])
			ii.pop_back()
			ii.remove_at(r)
		if ii:
			stars[ii[0]].special = StarSpecial.NONE # odd wormhole star
		pass

	func assign_marooned_heroes():
		var nmar = 0
		for si in stars:
			if stars[si].special == StarSpecial.MAROONED_HERO:
				nmar += 1
		var n = mini(maxi(nmar * 2, 20), leaders.size())
		if n == 0:
			return
		var ws = U.array(n, 1)
		for si in stars:
			var s: Star = stars[si]
			if s.special != StarSpecial.MAROONED_HERO:
				continue
			if n == 0:
				s.special = StarSpecial.NONE
				continue
			var r = weighted_roll(ws)
			var l: Leader = leaders[r]
			l.location = si
			l.status = LeaderStatus.MAROONED
			n -= 1

	func twiddle_initial_homeworlds():
		pass # TODO

	func idistance_sq(a: Vector2i, b: Vector2i) -> int:
		return (a - b).length_squared()

	func idistance(a: Vector2i, b: Vector2i) -> int:
		return int(ceil(sqrt(idistance_sq(a, b))))

	func max_planet_pop_for_player(pid: int, plid: int):
		return 20 # TODO

	func max_colony_pop(cid: int):
		return 20 # TODO

	func update_data():
		for si in stars:
			var s: Star = stars[si]
			for i in 2:
				size[i] = maxi(s.pos[i], size[i])
		size += Vector2i(100, 100)

	func player_race(plid: int):
		return races[players[plid].race]

	func print_stats():
		print("Game")
		print("  ", players.size(), " players")
		print("  ", races.size(), " races")
		print("  ", stars.size(), " stars")
		print("  ", planets.size(), " planets")
		print("  ", colonies.size(), " colonies")

	func print_star(sid: int):
		var s: Star = stars[sid]
		print(" star: #", sid, " ", U.obj_save(s))

func default_game():
	var g: Game = Game.new()
	g.config = default_config()
	g.settings = U.clone(settings_)
	var natives: Race = Race.new()
	natives.name = "Natives"
	natives.is_native = true
	g.add_race(natives)
	var droids: Race = Race.new()
	droids.name = "Androids"
	droids.traits.tolerant = 1
	droids.is_droid = true
	g.add_race(droids)
	return g

func generate_test_game():
	var g = Game.new()
	var plid = g.add_player()
	g.cur_player_id = plid
	var pl: Player = g.players[plid]
	pl.is_human = true
	pl.name = "Bladrov"
	pl.race = g.add_race()
	g.races[pl.race].name = "Human"

	# human sol
	var sid = g.add_star()
	var star: G.Star = g.stars[sid]
	star.name = "Sol"
	star.color = StarColor.YELLOW
	star.pos = Vector2i(100, 100)
	for i in 5:
		if i == 1:
			continue
		var pid = g.add_planet()
		var planet: G.Planet = g.planets[pid]
		planet.star = sid
		planet.size = {0: G.PlanetSize.TINY, 2: G.PlanetSize.LARGE}.get(i, 0)
		planet.minerals = {0: G.Minerals.RICH, 2: G.Minerals.POOR}.get(i, 0)
		planet.kind = {3: G.PlanetKind.ASTEROID_BELT, 4: G.PlanetKind.GAS_GIANT}.get(i, G.PlanetKind.PLANET)
		planet.climate = G.Climate.RADIATED if i == 0 else G.Climate.TERRAN
		planet.gravity = G.Gravity.LOWG if i == 0 else G.Gravity.NORMALG
		star.orbits[i] = pid
	var cid = g.add_colony()
	var colony: G.Colony = g.colonies[cid]
	colony.player = plid
	colony.planet = star.orbits[2]
	var pop: Pop = G.Pop.new()
	pop.race = pl.race
	pop.job = G.Job.FARMER
	for i in 5:
		colony.pop.push_back(pop)

	# elerian draconis
	plid = g.add_player()
	pl = g.players[plid]
	pl.is_human = false
	pl.name = "Karen"
	pl.race = g.add_race()
	g.races[pl.race].name = "Elerian"

	sid = g.add_star()
	star = g.stars[sid]
	star.name = "Draconis"
	star.color = StarColor.RED
	star.pos = Vector2i(200, 500)
	for i in 5:
		if i == 1:
			continue
		var pid = g.add_planet()
		var planet: G.Planet = g.planets[pid]
		planet.star = sid
		planet.size = {0: G.PlanetSize.TINY, 2: G.PlanetSize.LARGE}.get(i, 0)
		planet.minerals = {0: G.Minerals.RICH, 2: G.Minerals.POOR}.get(i, 0)
		planet.kind = {3: G.PlanetKind.ASTEROID_BELT, 4: G.PlanetKind.GAS_GIANT}.get(i, G.PlanetKind.PLANET)
		planet.climate = G.Climate.RADIATED if i == 0 else G.Climate.TERRAN
		planet.gravity = G.Gravity.LOWG if i == 0 else G.Gravity.NORMALG
		star.orbits[i] = pid
	cid = g.add_colony()
	colony = g.colonies[cid]
	colony.player = plid
	colony.planet = star.orbits[2]
	pop = G.Pop.new()
	pop.race = pl.race
	pop.job = G.Job.FARMER
	for i in 5:
		colony.pop.push_back(pop)

	g.update_data()
	game = g
