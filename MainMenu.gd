extends Control

onready var highscoreText = $Highscore
onready var animation = $AnimationPlayer
onready var logo = $Logo

var amplitude = 0.05
var time = 0.0
var speed = 2

func _ready():
	highscoreText.set_bbcode("HIGHSCORE: " + str(Global.highscore) + "m")
	pass

func _process(delta):
	time += delta * speed
	logo.scale = Vector2(amplitude * sin(time) + 1, amplitude * sin(time) + 1)

func _on_LENI_button_down():
	Global.Leni = true
	animation.play("FadeOut")


func _on_KIKO_button_down():
	Global.Leni = false
	animation.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene("res://src/Scenes/World.tscn")
