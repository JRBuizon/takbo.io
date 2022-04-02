extends Node2D

onready var animation = $AnimationPlayer

func fadeIn():
	animation.play("popIn")



func _on_SHARE_button_down():
	get_tree().change_scene("res://src/ShareScreen.tscn")


func _on_RETRY_button_down():
	get_tree().change_scene("res://src/World.tscn")


func _on_MENU_button_down():
	get_tree().change_scene("res://src/MainMenu.tscn")
