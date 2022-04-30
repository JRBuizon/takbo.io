extends Node2D


func _ready():
	yield(get_tree().create_timer(3), "timeout")
	$Tween.interpolate_property($Label, "position:y", 0.0, -20.0, 1.0, 10, Tween.EASE_OUT)
	$Tween.interpolate_property($Label, "modulate:a", 0.0, 255.0, 1.0, 10, Tween.EASE_OUT)
	
