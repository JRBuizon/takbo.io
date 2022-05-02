extends Node2D

var amplitude = 0.1
var time = 0
func _process(delta):
	time += delta * 3
	$TakboLogo.scale = Vector2(amplitude * sin(time) + 1.2, amplitude * sin(time) + 1.2)
	$Label.modulate.a = (amplitude + 1) * sin(time * 1.1)
	$Updated.scale = Vector2(amplitude * sin(time) + 1, amplitude * sin(time) + 1)
	
	if Input.is_action_just_pressed("tap"):
		get_tree().change_scene("res://src/Scenes/MainMenu.tscn")
