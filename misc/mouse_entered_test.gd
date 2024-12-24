extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_mouse_entered():
	print("entered cube")
	pass # Replace with function body.


func _on_area_3d_mouse_exited():
	print("exited cube")
	pass # Replace with function body.


func _on_area_3d_2_mouse_entered():
	print("entered sphere")
	pass # Replace with function body.


func _on_area_3d_2_mouse_exited():
	print("exited sphere")
	pass # Replace with function body.
