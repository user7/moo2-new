extends Node2D

var scene = preload("res://misc/aux_system.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randi_range(100, 400)
	pass

func _process(delta):
	pass

func _on_button_pressed():
	var instance = scene.instantiate()
	instance.position = Vector2(rng.randi_range(100, 400), rng.randi_range(100, 400))
	$Wins.add_child(instance)
