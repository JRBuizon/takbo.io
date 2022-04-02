extends Node2D

onready var score = $Camera2D/RichTextLabel
var scoreText = 0
var displayText = 0
var startedGame = false

var Plat = preload("res://src/Platform.tscn")
var pastYlevel = 488
var ylevel = 0

func _physics_process(delta):
	scoreText += delta * 10
	displayText = floor(scoreText)
	score.set_bbcode("[center][b]" + str(displayText) + "[/b][/center]")

func rand_ylevel():
	ylevel = pastYlevel-((randi() % 7 - 3) * 16)
	if pastYlevel == ylevel:
		var choice = randi() % 2
		if choice > 0:
			ylevel = pastYlevel-((randi() % 3 + 1) * 16)
		else:
			ylevel = pastYlevel+((randi() % 3 + 1) * 16)
		
	if ylevel < 424:
		ylevel = pastYlevel+((randi()%3 + 1)*16)
	
	if ylevel > 536:
		ylevel = pastYlevel-((randi()%3 + 1)*16)
	pastYlevel = ylevel
	return ylevel
	

func Plat_spawn():
	print("Spawning")
	var Plat_instance = Plat.instance()
	Plat_instance.position = Vector2(463, rand_ylevel())
	add_child(Plat_instance)

func _on_Area2D_area_entered(area):
	if area.name == "PlatHitBox":
		print("Resetting")
		area.get_parent().queue_free()
		Plat_spawn()
