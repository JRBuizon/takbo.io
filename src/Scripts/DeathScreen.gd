extends Node2D

onready var animation = $AnimationPlayer

func fadeIn():
	animation.play("popIn")



func _on_SHARE_button_down():
	get_parent().get_parent().call_deferred("exitScreen", "res://src/Scenes/ShareScreen.tscn")


func _on_RETRY_button_down():
	get_parent().get_parent().call_deferred("exitScreen", "res://src/Scenes/World.tscn")


func _on_MENU_button_down():
	get_parent().get_parent().call_deferred("exitScreen", "res://src/Scenes/MainMenu.tscn")
