extends Node2D

onready var tween = $Tween



func _on_SHARE_button_down():
	tween.interpolate_property($FirstPanel, "position",
		Vector2(0, 0), Vector2(-500, 0), 0.5,
		10, Tween.EASE_IN)
	tween.start()
