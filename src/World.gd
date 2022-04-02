extends Node2D

onready var score = $Camera2D/RichTextLabel
onready var player = $Player
onready var deathScr = $DeathScreen

var scoreText = 0
var displayText = 0
var startedGame = false

#var Plat = preload("res://src/Platform.tscn")
var pastYlevel = 488
var ylevel = 0

const totalVariations = 7
const absoluteVariations = 3
const snapHeight = 16
const highestPossible = 424
const lowestPossible = 536

var gameStart = false
var gameEnd = false

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up") and not gameStart:
		gameStart = true
	
	if gameStart and not gameEnd:
		scoreText += delta * 10

	displayText = floor(scoreText)
	score.set_bbcode("[center][b]" + str(displayText) + "m[/b][/center]")

func rand_ylevel():
	#Randomizes Y Level based on a randi from -3 to 3 multiplied by snapHeight
	ylevel = pastYlevel-((randi() % totalVariations - absoluteVariations) * snapHeight)
	
	if pastYlevel == ylevel: #If current Y Level is the same as the last Y Level
		var choice = randi() % 2 #Randomly pick 1 or 0
		if choice > 0: #If 0 go up and shuffle
			ylevel = pastYlevel-((randi() % absoluteVariations + 1) * snapHeight)
		else: #If not go down and shuffle
			ylevel = pastYlevel+((randi() % absoluteVariations + 1) * snapHeight)
		
	if ylevel < highestPossible: #If above highest Possible Y level go down and shuffle
		ylevel = pastYlevel+((randi()%absoluteVariations + 1)*snapHeight)
	
	if ylevel > lowestPossible: #If below lowest Possible Y level go up and shuffle
		ylevel = pastYlevel-((randi()%absoluteVariations + 1)*snapHeight)
	
	pastYlevel = ylevel #setting the current Y Level as the past Y Level for the next platform
	return ylevel #For putting in the Vector2 later
	
"""
func Plat_spawn():
	print("Spawning")
	var Plat_instance = Plat.instance()
	Plat_instance.position = Vector2(464, rand_ylevel())
	add_child(Plat_instance)
"""
func Player_dies():
	deathScr.fadeIn()
	player.playerDies()
	gameStart = false
	gameEnd = true

func _on_Area2D_area_entered(area):
	if area.name == "PlatHitBox":
		print("Resetting")
		area.get_parent().position = Vector2(464, rand_ylevel())
		#area.get_parent().queue_free()
		#Plat_spawn()
