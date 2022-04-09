extends Node2D

onready var tween = $Tween

func displayScreen():
	tween.interpolate_property(self, "scale",
		Vector2(0, 0), Vector2(1, 1), 0.7,
		10, Tween.EASE_OUT)
	tween.start()

func hideScreen():
	tween.interpolate_property(self, "scale",
		Vector2(1, 1), Vector2(0, 0), 0.7,
		10, Tween.EASE_IN)
	tween.start()

