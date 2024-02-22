extends Node2D

var grad = 2 * PI / 360
var R = 500
var RX = 200
var RY = 100
var r: float = 100
var O = Vector2(R/2, R/2)
var beta = 0
var pts = []

func mkline(obj, a, b):
	var l = Line2D.new()
	l.width = 1
	l.add_point(a + O)
	l.add_point(b + O)
	obj.add_child(l)

# Called when the node enters the scene tree for the first time.
func _ready():
	mkline($Draw, Vector2(-R/2, 0), Vector2(R/2, 0))
	mkline($Draw, Vector2(0, -R/2), Vector2(0, R/2))
	mkelips($Draw, Vector2.ZERO, RX, RY)
	redraw_marks()

func mkelips(obj, at, rx, ry):
	var e = Line2D.new()
	e.width = 1
	var pp
	var ni = 100
	for i in ni:
		var a = 2 * PI * i / (ni - 1)
		var cp = at + angle2ellips(a, rx, ry) + O
		if pp != null:
			e.add_point(pp)
			e.add_point(cp)
		pp = cp
	obj.add_child(e)

func angle2ellips(a, rx, ry) -> Vector2:
	return Vector2(rx * cos(a), ry *  sin(a))

func redraw_marks():
	for ch in $Marks.get_children():
		$Marks.remove_child(ch)

	pts.clear()
	pts.push_back(angle2ellips(beta, RX, RY))
	
	var d = asin(r / max(RX, RY))
	pts.push_back(solve(beta + d))
	pts.push_back(solve(beta - d))

	# recalc children
	var dx = Vector2(5, 5)
	var dy = Vector2(5, -5)
	for m in pts:
		mkline($Marks, m - dx, m + dx)
		mkline($Marks, m - dy, m + dy)
	mkelips($Marks, angle2ellips(beta, RX, RY), r, r)

func sq(x: float) -> float:
	return x * x

func f0(a):
	return sq(RX * (cos(a) - cos(beta))) + sq(RY * (sin(a) - sin(beta))) - sq(r)

func f1(a):
	return 2 * (- sq(RX) * (cos(a) - cos(beta)) * sin(a) + sq(RY) * (sin(a) - sin(beta)) * cos(a))

func solve(a):
	for i in 5:
		a -= f0(a) / f1(a)
	return angle2ellips(a, RX, RY)

func read_pressed(r1, r2, just: bool = false):
	for rv in [[r1, 1], [r2, -1]]:
		if Input.is_action_just_pressed(rv[0]) if just else Input.is_action_pressed(rv[0]):
			return rv[1]
	return 0

func _process(delta):
	var lr = read_pressed("move_left", "move_right")
	if lr != 0:
		beta -= lr * grad
		redraw_marks()
