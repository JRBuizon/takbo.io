extends Node2D

onready var tween = $Tween

func displayDeathScr():
	tween.interpolate_property(self, "scale",
		Vector2(0, 0), Vector2(0.5, 0.5), 0.7,
		10, Tween.EASE_OUT)
	tween.start()


func _on_SHARE_button_down():
	get_parent().get_parent().call_deferred("exitScreen", "res://src/Scenes/ShareScreen.tscn")


func _on_RETRY_button_down():
	get_parent().get_parent().call_deferred("exitScreen", "res://src/Scenes/World.tscn")


func _on_MENU_button_down():
	get_parent().get_parent().call_deferred("exitScreen", "res://src/Scenes/MainMenu.tscn")
