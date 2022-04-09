extends Node2D

onready var tween = $Tween
onready var score = $SCORE
signal button_pressed(scene_path)

func displayScreen():
	score.set_bbcode("[center][b]" + str(Global.score))
	tween.interpolate_property(self, "scale",
		Vector2(0, 0), Vector2(1, 1), 0.7,
		10, Tween.EASE_OUT)
	tween.start()
	
func hideScreen():
	tween.interpolate_property(self, "scale",
		Vector2(1, 1), Vector2(0, 0), 0.7,
		10, Tween.EASE_IN)
	tween.start()



func _on_SHARE_button_down():
	hideScreen()
	emit_signal("button_pressed", "res://src/Scenes/ShareScreen.tscn")


func _on_RETRY_button_down():
	hideScreen()
	emit_signal("button_pressed", "res://src/Scenes/World.tscn")


func _on_MENU_button_down():
	hideScreen()
	emit_signal("button_pressed", "res://src/Scenes/MainMenu.tscn")
