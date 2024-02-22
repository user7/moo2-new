extends Node3D

@onready var camera = $Camera3D
@onready var cursor = $Cursor

const ox = Vector3(1, 0, 0)
const oy = Vector3(0, 1, 0)
const oz = Vector3(0, 0, 1)
const orbit_color = Color(0.13, 0.16, 0.3) * 1.8
const camera_angle = 2 * PI * 30 / 360
const gas_giant_size = 1.5
const planet_size = {
	G.PlanetSize.TINY: 0.6,
	G.PlanetSize.SMALL: 0.8,
	G.PlanetSize.AVERAGE: 1,
	G.PlanetSize.LARGE: 1.2,
	G.PlanetSize.HUGE: 1.4
}
const omnilight_colors = [
	Color(0.4, 0.6, 1),
	Color(1, 1, 1),
	Color(1, 1, 0.6),
	Color(1, 0.9, 0.5),
	Color(1, 0.5, 0.3),
	Color(0.4, 0, 0.3)
]
const climate_names = [
	"toxic",
	"radiated",
	"barren",
	"desert",
	"tundra",
	"ocean",
	"swamp",
	"arid",
	"terran",
	"gaia",
]

var is_orbit_paused = false
var star_id: int

func init_scene(star_id_):
	star_id = star_id_

class PlanetData:
	var body: StaticBody3D
	var planet: MeshInstance3D
	var orbit_turn: Transform3D
	var axis: Vector3
	var axis_turn: float
	var starting_angle: float
	var radius: float
	var orbit_radius: float
	var planet_kind: int
	var texture_num: int
	var pid: int
	var orbit: int
	var cid: int = G.NOID

var planets: Array[PlanetData] = []

func cvector(c: float):
	return Vector3(c, c, c)

func _ready():
	camera.position = camera.position.rotated(ox, -camera_angle)
	camera.rotate(ox, -camera_angle)
	if G.game == null:
		generate_test_game()
	rebuild_planets()

func generate_test_game():
	var g = G.Game.new()
	
	var plid1 = g.add_player()
	var pl1: G.Player = g.players[plid1]
	pl1.is_human = true
	pl1.name = "Bladrov"

	var rid1 = g.add_race()
	g.races[rid1].name = "Human"
	pl1.race = rid1
	
	var sid = g.add_star()
	var star: G.Star = g.stars[sid]
	star.name = "Sol"
	star.color = 1
	for i in 5:
		if i == 1:
			star.orbits.push_back(G.NOID)
			continue
		var pid = g.add_planet()
		var planet: G.Planet = g.planets[pid]
		planet.star = sid
		planet.size = {0: G.PlanetSize.TINY, 2: G.PlanetSize.LARGE}.get(i, 0)
		planet.minerals = {0: G.Minerals.RICH, 2: G.Minerals.POOR}.get(i, 0)
		planet.kind = {3: G.PlanetKind.ASTEROID_BELT, 4: G.PlanetKind.GAS_GIANT}.get(i, G.PlanetKind.PLANET)
		planet.climate = G.Climate.RADIATED if i == 0 else G.Climate.TERRAN
		planet.gravity = G.Gravity.LOWG if i == 0 else G.Gravity.NORMALG
		star.orbits.push_back(pid)

	var cid = g.add_colony()
	var colony: G.Colony = g.colonies[cid]
	colony.player = plid1
	colony.planet = star.orbits[2]
	var pop = G.Pop.new()
	pop.player = plid1
	pop.job = G.Job.FARMER
	for i in 5:
		colony.pop.push_back(pop)

	G.game = g
	star_id = sid

func remove_children(obj):
	for c in obj.get_children():
		obj.remove_child(c)

func rebuild_planets():
	remove_children($Planets)
	remove_children($Orbits)
	remove_children($Markers)
	if G.game.stars[star_id] == null:
		$NoViewLabel.visible = true
		$Star.visible = false
		$Planets.visible = false
		$Orbits.visible = false
		return

	var star: G.Star = G.game.stars[star_id]
	$Star.texture = load("res://img/system/star/%s.svg" % star.color)
	$OmniLight3D.light_color = omnilight_colors[star.color]
	
	for oi in star.orbits.size():
		var pid = star.orbits[oi]
		if not pid in G.game.planets:
			continue
		var p: G.Planet = G.game.planets[pid]
		if p.kind == G.PlanetKind.ASTEROID_BELT:
			continue # TODO
		
		var pd = PlanetData.new()
		pd.starting_angle = oi * 10
		pd.radius = gas_giant_size if p.kind == G.PlanetKind.GAS_GIANT else planet_size[p.size]
		pd.orbit_radius = (oi + 2) * 3
		pd.planet_kind = p.climate
		pd.texture_num = pid
		pd.pid = pid
		pd.orbit = oi
		pd.cid = G.game.planet_to_colony(pid)

		var bbc = StaticBody3D.new()
		bbc.set_collision_layer(1)
		bbc.visible = true
		var bbsc = CollisionShape3D.new()
		bbsc.shape = SphereShape3D.new()
		bbsc.disabled = false

		var bbpc = MeshInstance3D.new()
		bbpc.mesh = SphereMesh.new()
		var climate = climate_names[p.climate] if p.kind == G.PlanetKind.PLANET else "gas_giant"
		var tname = "res://img/planets/%s/%s.png" % [climate, pd.texture_num]
		bbpc.mesh.material = StandardMaterial3D.new()
		bbpc.mesh.material.albedo_texture = load(tname)

		pd.planet = bbpc
		pd.body = bbc
		pd.orbit_turn = Transform3D().rotated(oy, 0.01)
		pd.body.position = ox.rotated(oy, pd.starting_angle) * pd.orbit_radius
		pd.axis_turn = 1
		pd.body.scale = cvector(pd.radius * 2)
		var axis_angle = PI / 8
		pd.axis = oy.rotated(oz, axis_angle)
		pd.body.rotate(oz, axis_angle)
		create_orbit_ring(pd.body.position, pd.radius + 0.1)
		$Planets.add_child(bbc)
		
		if pd.cid != G.NOID:
			var colony = G.game.colonies[pd.cid]
			var bbmc = Sprite3D.new()
			bbmc.position = pd.body.position - Vector3(1, -1, 0) * pd.radius
			bbmc.texture = load("res://img/system/colony_marker/%s.svg" % G.game.players[colony.player].banner)
			bbmc.visible = true
			$Markers.add_child(bbmc)
		bbc.add_child(bbpc)
		bbc.add_child(bbsc)
		planets.push_back(pd)
	pass

func create_orbit_ring(center, rad):	
	var path : MeshInstance3D = MeshInstance3D.new()
	path.mesh = ImmediateMesh.new()
	var material : StandardMaterial3D = StandardMaterial3D.new()
	path.material_override = material
	material.albedo_color = orbit_color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	path.mesh.clear_surfaces()
	path.mesh.surface_begin(Mesh.PRIMITIVE_LINES, path.material_override)
	var steps = 400
	var da = 2 * PI / steps
	var a = 0
	var cp: Vector3 = center.rotated(ox, camera_angle)
	cp[2] = 0
	var r2 = rad * rad
	var v_prev
	for k in steps + 1:
		var v_cur = center.rotated(oy, a)
		a += da
		var vp: Vector3 = v_cur.rotated(ox, camera_angle)
		vp[2] = 0
		if vp.distance_squared_to(cp) <= r2:
			if v_prev == null:
				continue # not initialized, opening fragment
			break # already initialized and too close, closing fragment
		if v_prev != null:
			path.mesh.surface_add_vertex(v_prev)
			path.mesh.surface_add_vertex(v_cur)
		v_prev = v_cur
	path.mesh.surface_end()
	$Orbits.add_child(path)

func read_pressed(r1, r2, just: bool = false):
	for rv in [[r1, 1], [r2, -1]]:
		if Input.is_action_just_pressed(rv[0]) if just else Input.is_action_pressed(rv[0]):
			return rv[1]
	return 0

var planet_n = -1
var oldpos = null
var curobj = null

func _process(delta):
	var pos = get_viewport().get_mouse_position()
	if pos != oldpos:
		oldpos = pos
		const RAY_LENGTH = 500000.0
		var ray_origin = camera.project_ray_origin(pos)
		var ray_end = ray_origin + camera.project_ray_normal(pos) * RAY_LENGTH
		var space_state = get_world_3d().direct_space_state
		var ray = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		ray.collide_with_bodies = true
		ray.set_collision_mask(1)
		var collider = space_state.intersect_ray(ray).get("collider")
		set_cursor(collider)
		
	var zoom = read_pressed("zoom out", "zoom in", true)
	if zoom != 0:
		zoom = 1.1 if zoom == 1 else 0.9
		camera.size = max(camera.size * zoom, 0.1)

	var lr = read_pressed("move_left", "move_right")
	if lr != 0:
		#grow_obj.scale *= (10 + lr) / 10.
		pass

	var updown = read_pressed("move_up", "move_down")
	if updown != 0:
		#grow_obj.rotate(oz, updown / 100.)
		pass

	for pd: PlanetData in planets:
		if pd.body and not is_orbit_paused:
			pd.body.rotate(pd.axis, pd.axis_turn * delta)

func set_cursor(obj):
	if obj == null or obj == curobj:
		return
	for pd in planets:
		if pd.body == obj:
			curobj = obj
			cursor.visible = true
			cursor.position = obj.position
			cursor.scale = obj.scale * 0.7
