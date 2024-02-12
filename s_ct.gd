extends PanelContainer

var _cur_val = 0
var _labels = ["Label 1", "Label 2", "Label 3"]
var _pics = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func size():
	return _labels.size()

func init_clickthrough(caption, labels, pics, val = null):
	$VBoxContainer/Caption.text = caption
	_pics = pics
	_labels = labels
	show_pic(0 if val == null else val)

func show_pic(add: int):
	if size() > 0:
		_cur_val = (_cur_val + add + size()) % size()
	if _cur_val < _labels.size():
		$VBoxContainer/Labels.text = _labels[_cur_val]
	if _cur_val < _pics.size():
		$VBoxContainer/Pics.texture = load(_pics[_cur_val])

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_WHEEL_UP]:
				show_pic(1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				show_pic(-1)
