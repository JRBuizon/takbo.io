extends Node2D

onready var score = $Camera2D/Score
onready var player = $Player
onready var deathScr = $Camera2D/DeathScreen
onready var animation = $AnimationPlayer

onready var friendScore = $Camera2D/friendScore
onready var friendName = $Camera2D/friendName
onready var progressBar = $Camera2D/toFriendScore

#Parallax Layers
onready var DTClouds = $DT/Clouds
onready var DTFar = $DT/FarSprites
onready var DTMid = $DT/MidSprites
onready var DTNear = $DT/NearSprites
onready var DTCars = $DT/Cars
onready var DTRailings = $DT/Railings
onready var DTGround = $DT/Ground

export(float) var CLOUD_SPEED = -20
export(float) var FAR_SPEED = -20
export(float) var MID_SPEED = -20
export(float) var NEAR_SPEED = -20
export(float) var CARS_SPEED = -20
export(float) var RAILINGS_SPEED = -20
export(float) var GROUND_SPEED = -20


var scoreText = 0
var displayText = 0
var startedGame = false
var scenePath

#var Plat = preload("res://src/Platform.tscn")
var pastYlevel = 488
var ylevel = 0

const totalVariations = 6
const absoluteVariationsD = 3
const absoluteVariationsU = 2
const snapHeight = 16
const highestPossible = 424
const lowestPossible = 536

var gameStart = false
var gameEnd = false

func _ready():
	if Global.friendName:
		friendName.set_bbcode("Beat " + Global.friendName + "!")
		friendScore.set_bbcode("[right]" + Global.friendScore + "m")
		progressBar.set_max(int(Global.friendScore))
	
	else:
		progressBar.visible = false
	
	animation.play("FadeIn")

func _process(delta):
	DTClouds.motion_offset.x += CLOUD_SPEED * delta
	DTFar.motion_offset.x += FAR_SPEED * delta
	DTMid.motion_offset.x += MID_SPEED * delta
	DTNear.motion_offset.x += NEAR_SPEED * delta
	DTCars.motion_offset.x += CARS_SPEED * delta
	DTRailings.motion_offset.x += RAILINGS_SPEED * delta
	DTGround.motion_offset.x += GROUND_SPEED * delta
	

func _physics_process(delta):
	if Input.is_action_just_pressed("tap") and not gameStart:
		gameStart = true
	
	if gameStart and not gameEnd:
		scoreText += delta * 7
		if Global.friendName and not scoreText > int(Global.friendScore):
			progressBar.set_value(scoreText)

	displayText = floor(scoreText)
	score.set_bbcode("[center][b]" + str(displayText) + "m[/b][/center]")

func rand_ylevel():
	#Randomizes Y Level based on a randi from -3 to 3 multiplied by snapHeight
	ylevel = pastYlevel-((randi() % totalVariations - absoluteVariationsD) * snapHeight)
	
	if pastYlevel == ylevel: #If current Y Level is the same as the last Y Level
		var choice = randi() % 2 #Randomly pick 1 or 0
		if choice > 0: #If 0 go up and shuffle
			ylevel = pastYlevel-((randi() % absoluteVariationsU + 1) * snapHeight)
		else: #If not go down and shuffle
			ylevel = pastYlevel+((randi() % absoluteVariationsD + 1) * snapHeight)
		
	if ylevel < highestPossible: #If above highest Possible Y level go down and shuffle
		ylevel = pastYlevel+((randi()%absoluteVariationsD + 1)*snapHeight)
	
	if ylevel > lowestPossible: #If below lowest Possible Y level go up and shuffle
		ylevel = pastYlevel-((randi()%absoluteVariationsU + 1)*snapHeight)
	
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
	if displayText > Global.highscore:
		Global.highscore = displayText
	deathScr.displayDeathScr()
	player.playerDies()
	gameStart = false
	gameEnd = true

func _on_Area2D_area_entered(area):
	if area.name == "PlatHitBox":
		#print("Resetting")
		area.get_parent().position = Vector2(464, rand_ylevel())
		#area.get_parent().queue_free()
		#Plat_spawn()

func exitScreen(SCENE_PATH):
	animation.play("FadeOut")
	scenePath = SCENE_PATH
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene(scenePath)
