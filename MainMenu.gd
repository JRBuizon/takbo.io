extends Control

onready var highscoreText = $Highscore
onready var animation = $AnimationPlayer

func _ready():
	highscoreText.set_bbcode("HIGHSCORE: " + str(Global.highscore) + "m")
	pass



func _on_LENI_button_down():
	Global.Leni = true
	animation.play("FadeOut")


func _on_KIKO_button_down():
	Global.Leni = false
	animation.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene("res://src/Scenes/World.tscn")
