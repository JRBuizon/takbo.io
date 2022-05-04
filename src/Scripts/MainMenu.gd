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
var audio: AudioStreamPlayer

onready var buttonSfx = preload("res://src/Assets/Sounds/SFX/buttonv1.mp3")
onready var main_menu_music = preload("res://src/Assets/Sounds/music_menu.mp3")

func _ready():
	audio = AudioStreamPlayer.new()
	audio.volume_db = -10
	add_child(audio)
	audio.stream = buttonSfx
	
	# Checks the current state of the music player
	sfxM.visible = Global.is_music_muted()
	sfxU.visible = not Global.is_music_muted()
	
	highscoreText.set_bbcode("HIGHSCORE: " + str(Global.highscore) + "m")
	Global.play_music(main_menu_music)
	

func _process(delta):
	time += delta * speed
	logo.scale = Vector2(amplitude * sin(time) + 1, amplitude * sin(time) + 1)


func _on_KIKO_button_down():
	audio.play()
	Global.Character = Global.Kiko
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/World.tscn"
	Global.track_event("PickKiko")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene(scenePath)


func _on_LENI_button_down():
	audio.play()
	Global.Character = Global.Leni
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/World.tscn"
	Global.track_event("PickLeni")
	
func _on_GAB_button_down():
	audio.play()
	Global.Character = Global.Gab
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/World.tscn"
	Global.track_event("PickGab")

func _on_STAR_button_down():
	audio.play()
	Global.score = Global.highscore
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/ShareScreen.tscn"


func _on_SFX_toggled(_button_pressed):
	audio.play()
	Global.toggle_mute()
	sfxM.visible = Global.is_music_muted()
	sfxU.visible = not Global.is_music_muted()


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "FadeOut":
		Global.stop_music()

func _on_INFO_pressed():
	JavaScript.eval('window.location.replace("https://takbo.io/info")')


func _on_GAB_pressed():
	audio.play()
	Global.Character = Global.Gab
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/World.tscn"
	Global.track_event("PickGab")
