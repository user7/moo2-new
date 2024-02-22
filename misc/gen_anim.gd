extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = 100
	var a = 40
	var img = Image.create(n, n, false, Image.FORMAT_RGBA8)
	for i in a:
		for x in [i, n - 1 - i]:
			for ydy in [[0, 1], [n - 1, -1]]:
				var y = ydy[0]
				var dy = ydy[1]
				var w := 4
				for nd in 3 * w:
					var xy = [x, y + dy * nd]
					var col = [Color.BLUE, Color.PAPAYA_WHIP, Color.PLUM][nd / w % 3]
					for c in 2:
						img.set_pixel(xy[c], xy[1 - c], col)
	$TextureRect.texture = ImageTexture.create_from_image(img)

func anim_todo():
	var anim_player: AnimationPlayer = $AnimationPlayer

	var anim_root_node: Node = anim_player.get_node(anim_player.root_node)
	var sprite_path: NodePath = anim_root_node.get_path_to(sprite)	
	var sprite_frame_path: NodePath = "%s:frame" % sprite_path
		
	var anim_length: float = 10
	var frame_count: int = 10

	var anim := Animation.new()
	anim.length = anim_length
	anim.loop_mode = Animation.LOOP_LINEAR # loop?

	var frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(frame_track_id, sprite_frame_path)

	for frame_index in frame_count:
		var time: float = frame_index / float(frame_count) * anim_length
		anim.track_insert_key(frame_track_id, time, frame_index)

	anim_player.add_animation("anim_name", anim)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
