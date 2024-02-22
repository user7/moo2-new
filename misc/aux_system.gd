extends Node2D

var drag = false


func _ready():
	pass # Replace with function body.


func _process(delta):
	$SubViewportContainer/SubViewport/RigidBody3D.rotate(Vector3(0, 1, 0), delta)
	pass


func _on_input(event):
	if event is InputEventMouseButton:
		drag = event.pressed
	elif event is InputEventMouseMotion && drag:
		position += Vector2(event.relative)


func _on_close():
	self.queue_free()


func _on_gui_input(event):
	_on_input(event)


func _on_area_3d_mouse_entered():
	print("entered")
	pass # Replace with function body.



func _on_area_3d_mouse_exited():
	print("left")
	pass # Replace with function body.
