extends Control

# i = 1..10, title is empty when loading
signal slot_selected(n: int, title: String)

var do_load = false
var saves = []

func _ready():
	if do_load:
		$VBox/Panel/MarginContainer/Save.set_text("Load")
	for i in range(1, 11):
		var meta: G.SaveFileMeta = G.load_game_meta(i)
		saves.append(meta)
		var item = get_node("VBox/Save%d" % i)
		if item == null:
			continue
		var edit: LineEdit = item.get_node("Title")
		edit.connect("focus_entered", func(): _on_focus_entered(edit, i, true))
		edit.connect("focus_exited", func(): _on_focus_entered(edit, i, false))
		edit.connect("gui_input", func(event): _on_item_click(event, edit, i))
		if do_load and not meta:
			edit.set_editable(false)
			edit.set_focus_mode(FOCUS_NONE)
		if meta:
			var stardate = item.get_node("Stardate")
			stardate.set_text("Stardate:" + meta.stardate)
			stardate.set_visible(true)
			var date = item.get_node("Date")
			date.set_text(meta.date)
			date.set_visible(true)
			edit.set_text(meta.title)
			match meta.game_type:
				G.GAME_TYPE_SINGLE_PLAYER: 
					item.get_node("GameType1").set_visible(true)
				G.GAME_TYPE_HOTSEAT, G.GAME_TYPE_NETWORK:
					item.get_node("GameType2").set_visible(true)
				_:
					pass


func _process(delta):
	pass


func _on_cancel_pressed():
	queue_free()


class CurEdit:
	var edit: LineEdit
	var text: String
	var n: int


var cur_edit = null


func _on_save_pressed():
	var ce = cur_edit
	if ce:
		cur_edit == null
		handle_save(ce.n, ce.edit.get_text())


func handle_save(n: int, text: String):
	#print("handle_save emit ", n, " > ", text)
	slot_selected.emit(n, text)
	queue_free()


func _on_item_click(event: InputEvent, edit: LineEdit, i):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			var ce = cur_edit
			cur_edit = null
			handle_save(ce.n, ce.edit.get_text())
		if event.keycode == KEY_ESCAPE:
			cancel_current_edit()


func cancel_current_edit():
	if cur_edit:
		cur_edit.edit.set_text(cur_edit.text)
		cur_edit = null


func _on_focus_entered(edit: LineEdit, i, entered):
	if do_load:
		if saves[i - 1]:
			handle_save(i, "")
		return
	if entered:
		cancel_current_edit()
		var ce = CurEdit.new()
		ce.text = edit.get_text()
		ce.edit = edit
		ce.n = i
		cur_edit = ce
		if saves[i - 1] == null:
			edit.set_text("")
		#print("focus entered save cur_edit ", cur_edit)
	else:
		pass
		#print("focus exited save cur_edit ", cur_edit)
