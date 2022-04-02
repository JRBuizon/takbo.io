extends Control

onready var titleText = $RichTextLabel


func _ready():
	pass



func _on_LENI_button_down():
	get_tree().change_scene("res://src/World.tscn")


func _on_KIKO_button_down():
	get_tree().change_scene("res://src/World.tscn")
