extends Node2D

onready var animation = $AnimationPlayer

func _ready():
	animation.play("Fade")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://src/World.tscn")
