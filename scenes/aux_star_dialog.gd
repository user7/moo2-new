extends Control

@onready var camera = $SVC/SV/Camera3D
@onready var cursor = $SVC/SV/Cursor
@onready var transient_node = $SVC/SV/Transient
@onready var star_node = $SVC/SV/Star
@onready var unknown_system_label_node = $UnknownSystemLabel
@onready var svc_node = $SVC
@onready var omnilight_node = $SVC/SV/OmniLight3D
@onready var world_environment_node = $SVC/SV/WorldEnvironment
@onready var info_label_node: Label = $SVC/SV/Info/Label
@onready var caption_node: Label = $Caption
@onready var roids = $SVC/SV/Asteroids

var star_id: int
var drag = false

const ox = Vector3(1, 0, 0)
const oy = Vector3(0, 1, 0)
const oz = Vector3(0, 0, 1)
const orbit_color = Color(0.13, 0.16, 0.3) * 1.8
const gas_giant_size = 1.5
const planet_size = {
	G.PlanetSize.TINY: 0.7,
	G.PlanetSize.SMALL: 0.75,
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
	Color(0.4, 0, 0.3),
	Color(0.5, 0, 0.5),
]
const climate_names = [
	"Toxic",
	"Radiated",
	"Barren",
	"Desert",
	"Tundra",
	"Ocean",
	"Swamp",
	"Arid",
	"Terran",
	"Gaia",
]
const size_names = [
	"Tiny",
	"Small",
	"Average",
	"Large",
	"Huge",
]
const minerals_names = [
	"Ultra Poor",
	"Poor",
	"Abundant",
	"Rich",
	"Ultra Rich",
]
const gravity_names = [
	"Low G",
	"Normal",
	"Heavy G",
]
const numerals = [
	"I",
	"II",
	"III",
	"IV",
	"V",
]

func cvector(c: float):
	return Vector3(c, c, c)

func init_scene(star_id_):
	star_id = star_id_

class PlanetData:
	var body: Area3D
	var axis: Vector3
	var axis_turn: float
	var starting_angle: float
	var radius: float
	var orbit_radius: float
	var texture_num: int
	var pid: int
	var oid: int
	var cid: int = G.NOID

var planets_map: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	if G.game == null:
		G.generate_test_game()
		var g = G.game
		var plid = g.cur_player_id
		for ci in g.colonies:
			var c: G.Colony = g.colonies[ci]
			if c.player == plid:
				star_id = g.planets[c.planet].star
				break
	info_label_node.visible = false
	rebuild_planets()

func remove_children(obj):
	for c in obj.get_children():
		obj.remove_child(c)

func rebuild_planets():
	remove_children(transient_node)

	if G.game.stars[star_id] == null:
		unknown_system_label_node.visible = true
		caption_node.text = "Unknown"
		svc_node.visible = false
		return

	var star: G.Star = G.game.stars[star_id]
	caption_node.text = "Star System %s" % star.name
	star_node.texture = load("res://img/system/star/%s.svg" % star.color)
	omnilight_node.light_color = omnilight_colors[star.color]
	
	planets_map = {}
	for oid in star.orbits.size():
		var pid = star.orbits[oid]
		var roid = roids.get_children()[oid]
		roid.visible = false
		if not pid in G.game.planets:
			continue

		var p: G.Planet = G.game.planets[pid]
		var pd = PlanetData.new()
		pd.starting_angle = oid * 10
		pd.radius = gas_giant_size if p.kind == G.PlanetKind.GAS_GIANT else planet_size[p.size]
		pd.orbit_radius = (oid + 2) * 3
		pd.texture_num = pid % 8
		pd.pid = pid
		pd.oid = oid
		pd.cid = G.game.planets[pid].colony
		planets_map[oid] = pd

		if p.kind == G.PlanetKind.ASTEROID_BELT:
			generate_roid(roid, pd)
		else:
			generate_planet(pd)

func generate_roid(roid: Area3D, pd: PlanetData):
	var v1in
	var v1out
	var arr = []
	const maxi = 100
	for i in maxi + 1:
		var alpha = i * 2 * PI / maxi
		var v2in = Vector3(pd.orbit_radius - 0.3, 0, 0).rotated(oy, alpha)
		var v2out = Vector3(pd.orbit_radius + 0.3, 0, 0).rotated(oy, alpha)
		if i:
			arr.append_array([v1in, v1out, v2in])
			arr.append_array([v1out, v2in, v2out])
		v1in = v2in
		v1out = v2out
	roid.get_child(0).shape.set_faces(arr)
	roid.mouse_entered.connect(func(): set_cursor(pd.oid))
	roid.visible = true

func generate_planet(pd: PlanetData):
	var body = Area3D.new()
	body.input_ray_pickable = true
	body.mouse_entered.connect(func(): set_cursor(pd.oid))

	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = SphereShape3D.new()
	collision_shape.disabled = false
	body.add_child(collision_shape)

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = SphereMesh.new()
	var p: G.Planet = G.game.planets[pd.pid]	
	var climate = climate_names[p.climate].to_lower() if p.kind == G.PlanetKind.PLANET else "gas_giant"
	var tname = "res://img/planets/%s/%s.png" % [climate, pd.texture_num]
	mesh_instance.mesh.material = StandardMaterial3D.new()
	mesh_instance.mesh.material.albedo_texture = load(tname)
	body.add_child(mesh_instance)

	pd.body = body
	pd.body.position = ox.rotated(oy, pd.starting_angle) * pd.orbit_radius
	pd.axis_turn = 1
	pd.body.scale = cvector(pd.radius * 2)
	var axis_angle = PI / 8
	pd.axis = oy.rotated(oz, axis_angle)
	pd.body.rotate(oz, axis_angle)
	transient_node.add_child(body)

	create_orbit_ring(pd.body.position, pd.radius + 0.1)
	
	if pd.cid != G.NOID:
		var colony = G.game.colonies[pd.cid]
		var marker = Sprite3D.new()
		marker.position = pd.body.position - Vector3(1, -1, 0) * pd.radius
		marker.texture = load("res://img/system/colony_marker/%s.svg" % G.game.players[colony.player].banner)
		marker.visible = true
		transient_node.add_child(marker)

func create_orbit_ring(center, rad):	
	var path : MeshInstance3D = MeshInstance3D.new()
	path.mesh = ImmediateMesh.new()
	var mat : StandardMaterial3D = StandardMaterial3D.new()
	path.material_override = mat
	mat.albedo_color = orbit_color
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	path.mesh.clear_surfaces()
	path.mesh.surface_begin(Mesh.PRIMITIVE_LINES, path.material_override)
	var steps = 400
	var da = 2 * PI / steps
	var a = 0
	var camera_angle = camera.rotation[0]
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
	transient_node.add_child(path)

func _on_close_pressed():
	queue_free()

func read_pressed(r1, r2, just: bool = false):
	for rv in [[r1, 1], [r2, -1]]:
		if Input.is_action_just_pressed(rv[0]) if just else Input.is_action_pressed(rv[0]):
			return rv[1]
	return 0

func _process(delta):
	#var zoom = read_pressed("zoom out", "zoom in", true)
	#if zoom != 0:
		#zoom = 1.1 if zoom == 1 else 0.9
		#camera.size = max(camera.size * zoom, 0.1)

	var lr = read_pressed("move_left", "move_right")
	if lr != 0:
		#grow_obj.scale *= (10 + lr) / 10.
		pass

	var updown = read_pressed("move_up", "move_down")
	if updown != 0:
		#grow_obj.rotate(oz, updown / 100.)
		pass

	for oi in planets_map:
		var pd: PlanetData = planets_map[oi]
		if pd.body:
			pd.body.rotate(pd.axis, pd.axis_turn * delta)

func set_cursor(oi):
	if oi == -1:
		cursor.visible = false
		return
	var pd = planets_map[oi]
	var planet: G.Planet = G.game.planets[pd.pid]
	var colony: G.Colony
	var colony_owner = ""
	if pd.cid != G.NOID:
		colony = G.game.colonies[pd.cid]
		colony_owner = " (%s)" % G.game.player_race(colony.player).name
	
	cursor.visible = planet.kind != G.PlanetKind.ASTEROID_BELT
	if cursor.visible:
		cursor.position = pd.body.position
		cursor.scale = pd.body.scale * 0.4
	
	var lines = []
	if planet.kind == G.PlanetKind.PLANET:
		lines.push_back("%s %s%s" % [G.game.stars[star_id].name, numerals[pd.oid], colony_owner])
		lines.push_back("%s, %s" % [size_names[planet.size], climate_names[planet.climate]])
		if colony:
			lines.push_back("%s/%s pop" % [colony.pop.size(), G.game.max_colony_pop(pd.cid)])
		else:
			lines.push_back("%s max pop" % G.game.max_planet_pop_for_player(pd.pid, G.game.cur_player_id))
		var minerals = minerals_names[planet.minerals]
		var gravity = "" if planet.gravity == G.Gravity.NORMALG else ", %s" % gravity_names[planet.gravity]
		lines.push_back("%s%s" % [minerals, gravity])
	elif planet.kind == G.PlanetKind.ASTEROID_BELT:
		lines = ["Asteroid (uninhabitable)"]
	elif planet.kind == G.PlanetKind.GAS_GIANT:
		lines = ["Gas Giant (uninhabitable)"]

	info_label_node.text = "\n".join(lines)
	info_label_node.size = info_label_node.get_minimum_size() 
	info_label_node.visible = true

func _on_gui_input(event):
	if event is InputEventMouseButton:
		drag = event.pressed
	elif event is InputEventMouseMotion && drag:
		position += Vector2(event.relative)

