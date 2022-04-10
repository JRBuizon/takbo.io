extends Node2D

onready var score = $Score
onready var player = $Player
onready var deathScr = $DeathScreen
onready var animation = $AnimationPlayer
onready var confirmScr = $ConfirmExitScreen
onready var tween = $Tween

onready var sfxM = $SfXmuted
onready var sfxU = $SfXunmuted

onready var friendScore = $friendScore
onready var friendName = $friendName
onready var progressBar = $toFriendScore
onready var tap = $Tap

onready var parallax = $DT
#Parallax Layers
onready var DTClouds = $DT/Clouds
onready var DTFar = $DT/FarSprites
onready var DTMid = $DT/MidSprites
onready var DTNear = $DT/NearSprites
onready var DTCars = $DT/Cars

#onready var NTBG = $DT/Background/NTBackground
#onready var NTClouds = $DT/Clouds/NTClouds
#onready var NTFar = $DT/FarSprites/NTFar
#onready var NTMid = $DT/MidSprites/NTMid
#onready var NTNear = $DT/NearSprites/NTNear
#onready var NTCars = $DT/Cars/NTCars

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
var scenePath = ""
var amplitude = 1
var nightTime = 300

var pastYlevel = 512
var ylevel = 0

const totalVariations = 5
const absoluteVariationsD = 2
const absoluteVariationsU = 2
const snapHeight = 32
const highestPossible = 384
const lowestPossible = 608

var gameStart = false
var gameEnd = false

func _ready():
	if Global.friendName:
		friendName.set_bbcode("[i]Beat " + Global.friendName + "!")
		friendScore.set_bbcode("[right][i]" + Global.friendScore + "m")
		progressBar.set_max(int(Global.friendScore))
		$FriendBeat/Label2.text = Global.friendName
	
	elif not Global.friendName and Global.highscore > 0:
		friendName.set_bbcode("[i]Your highscore: " + str(Global.highscore) + "m")
		progressBar.set_max(int(Global.highscore))
		$FriendBeat/Label2.text = "Your highscore!"
		
	parallax.transform.origin = Vector2(randomizeParallax(), 360)
	animation.play("FadeIn")

func _process(delta):
	DTClouds.motion_offset.x += CLOUD_SPEED * delta
	DTFar.motion_offset.x += FAR_SPEED * delta
	DTMid.motion_offset.x += MID_SPEED * delta
	DTNear.motion_offset.x += NEAR_SPEED * delta
	DTCars.motion_offset.x += CARS_SPEED * delta
	
	if Global.friendName and displayText == int(Global.friendScore):
		tween.interpolate_property($FriendBeat, "position:y", -150.0, -30.0, 2.0, 10, Tween.EASE_OUT)
		tween.start()
	elif not Global.friendName and displayText == Global.highscore and Global.highscore > 0:
		tween.interpolate_property($FriendBeat, "position:y", -150.0, -30.0, 2.0, 10, Tween.EASE_OUT)
		tween.start()
			
	#var time = delta * 3
	#tap.scale = Vector2(amplitude * sin(time) + 1, amplitude * sin(time) + 1)
	

func _physics_process(delta):
	if not gameStart and Input.is_action_just_pressed("tap"):
			gameStart = true
	
	if gameStart and not gameEnd:
		scoreText += delta * 7
		if Global.friendName and not scoreText > int(Global.friendScore):
			progressBar.set_value(scoreText)
		elif not Global.friendName and not scoreText > int(Global.highscore):
			progressBar.set_value(scoreText)

	displayText = floor(scoreText)
	score.set_bbcode("[center][b]" + str(displayText) + "[/b]" + "\n[i]meters[/i][/center]")
	
#	if displayText == nightTime:
#		tween.interpolate_property(NTBG, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
#		tween.interpolate_property(NTClouds, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
#		tween.interpolate_property(NTFar, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
#		tween.interpolate_property(NTMid, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
#		tween.interpolate_property(NTNear, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
#		tween.interpolate_property(NTCars, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
#		tween.start()
		
func rand_ylevel():
	#Randomizes Y Level based on a randi from -3 to 3 multiplied by snapHeight
	ylevel = pastYlevel-((randi() % totalVariations - absoluteVariationsD) * snapHeight)
	
	if pastYlevel == ylevel and displayText >= 250: #If current Y Level is the same as the last Y Level
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

func player_dies():
	if displayText > Global.highscore:
		Global.highscore = displayText
	Global.score = displayText
	deathScr.displayScreen()
	player.playerDies()
	gameStart = false
	gameEnd = true

func randomizeParallax():
	var randomX = -(randi()%5461 + 1)
	print(randomX)
	return randomX
	
func _on_Area2D_area_entered(area):
	if area.name == "PlatHitBox":
		area.get_parent().position = Vector2(616, rand_ylevel())

func _on_DeathScreen_button_pressed(scene_path):
	animation.play("FadeOut")
	scenePath = scene_path

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene(scenePath)


func _on_SFX_toggled(button_pressed):
	if button_pressed:
		sfxM.visible = true
		sfxU.visible = false
	
	if not button_pressed:
		sfxM.visible = false
		sfxU.visible = true


func _on_EXIT_button_down():
	get_tree().paused = true
	confirmScr.displayScreen()


func _on_CONFIRM_EXIT_button_down():
	get_tree().paused = false
	player.playerDies()
	confirmScr.hideScreen()
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/MainMenu.tscn"


func _on_CANCEL_button_down():
	get_tree().paused = false
	confirmScr.hideScreen()
