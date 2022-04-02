extends Node2D

onready var animation = $AnimationPlayer

func fadeIn():
	animation.play("popIn")

