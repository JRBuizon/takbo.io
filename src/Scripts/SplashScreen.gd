extends Node2D

onready var animation = $AnimationPlayer
onready var logo = $Logo
onready var chatBox = $TitleChatBox

var chatAmplitude = 5
var amplitude = 0.1
var chatTime = 0.0
var time = 0.0
var chatSpeed = 3
var speed = 2


func _process(delta):
	time += delta * speed
	chatTime += delta * chatSpeed
	logo.scale = Vector2(amplitude * sin(time) + 1, amplitude * sin(time) + 1)
	chatBox.rotation_degrees = chatAmplitude * sin(chatTime)


func _on_AnimationPlayer_animation_finished(_anim_name):
	get_tree().change_scene("res://src/Scenes/MainMenu.tscn")
