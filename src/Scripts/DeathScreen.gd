extends Node2D

onready var tween = $Tween
signal button_pressed(scene_path)

func displayDeathScr():
	tween.interpolate_property(self, "scale",
		Vector2(0, 0), Vector2(1.25, 1.25), 0.7,
		10, Tween.EASE_OUT)
	tween.start()


func _on_SHARE_button_down():
	emit_signal("button_pressed", "res://src/Scenes/ShareScreen.tscn")


func _on_RETRY_button_down():
	emit_signal("button_pressed", "res://src/Scenes/World.tscn")


func _on_MENU_button_down():
	emit_signal("button_pressed", "res://src/Scenes/MainMenu.tscn")
