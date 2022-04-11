extends Control

onready var highscoreText = $Highscore
onready var animation = $AnimationPlayer
onready var logo = $Logo
onready var sfxM = $SfXmuted
onready var sfxU = $SfXunmuted

var scenePath = ""

var amplitude = 0.05
var time = 0.0
var speed = 2

onready var main_menu_music = preload("res://src/Assets/Sounds/music_menu.mp3")

func _ready():
	# Checks the current state of the music player
	sfxM.visible = Global.is_music_muted()
	sfxU.visible = not Global.is_music_muted()
	highscoreText.set_bbcode("HIGHSCORE: " + str(Global.highscore) + "m")
	Global.play_music(main_menu_music)
	yield(get_tree().create_timer(1.0), "timeout")
	$SFX.pressed = true

	$SFX.pressed = false
	

func _process(delta):
	time += delta * speed
	logo.scale = Vector2(amplitude * sin(time) + 1, amplitude * sin(time) + 1)


func _on_KIKO_button_down():
	Global.Leni = false
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/World.tscn"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene(scenePath)


func _on_LENI_button_down():
	Global.Leni = true
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/World.tscn"


func _on_STAR_button_down():
	Global.score = Global.highscore
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/ShareScreen.tscn"


func _on_SFX_toggled(button_pressed):
	Global.toggle_mute()
	sfxM.visible = Global.is_music_muted()
	sfxU.visible = not Global.is_music_muted()


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "FadeOut":
		Global.stop_music()
