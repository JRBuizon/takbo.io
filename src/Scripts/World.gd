extends Node2D

onready var score = $WorldLayer/Score
onready var player = $WorldLayer/Player
onready var deathScr = $CanvasLayer/DeathScreen
onready var animation = $AnimationPlayer
onready var confirmScr = $CanvasLayer/ConfirmExitScreen
onready var tween = $Tween

onready var sfxM = $WorldLayer/SfXmuted
onready var sfxU = $WorldLayer/SfXunmuted

onready var friendScore = $WorldLayer/friendScore
onready var friendName = $WorldLayer/friendName
onready var progressBar = $WorldLayer/toFriendScore
onready var tap = $WorldLayer/Tap

onready var parallax = $DT
#Parallax Layers
onready var DTClouds = $DT/Clouds
onready var DTFar = $DT/FarSprites
onready var DTMid = $DT/MidSprites
onready var DTNear = $DT/NearSprites
onready var DTCars = $DT/Cars
onready var crowd = $ParallaxBackground/ParallaxLayer

export(float) var CLOUD_SPEED = -20
export(float) var FAR_SPEED = -20
export(float) var MID_SPEED = -20
export(float) var NEAR_SPEED = -20
export(float) var CARS_SPEED = -20


var scoreText = 0
var displayText = 0
var startedGame = false
var scenePath = ""
var amplitude = 0.2
var time = 0

var pastYlevel = 448
var ylevel = 0

const totalVariations = 5
const absoluteVariationsD = 2
const absoluteVariationsU = 2
const snapHeight = 32
const highestPossible = 320
const lowestPossible = 544

var gameStart = false
var gameEnd = false
var friendBeat = false
var hasBeatScore = false
var hasHeld = false

onready var music_gab = preload("res://src/Assets/Sounds/gab_theme.mp3")
onready var music_start = preload("res://src/Assets/Sounds/music_start.mp3")
onready var music_harder = preload("res://src/Assets/Sounds/music_harder.mp3")
onready var music_new_record = preload("res://src/Assets/Sounds/music_new_record.mp3")
onready var mSfx = preload("res://src/Assets/Sounds/SFX/100m.mp3")
onready var buttonSfx = preload("res://src/Assets/Sounds/SFX/buttonv1.mp3")

var score_to_beat = int(Global.friendScore) if Global.friendName else Global.highscore

var audio: AudioStreamPlayer

func _ready():
	$WorldLayer/PUtimer.visible = false
	Global.hasPU = false
	#jump and death sfx
	audio = AudioStreamPlayer.new()
	audio.volume_db = -10
	add_child(audio)
	audio.pause_mode = Node.PAUSE_MODE_PROCESS
	
	if Global.friendName:
		friendName.set_bbcode("[i]Beat " + Global.friendName + "!")
		friendScore.set_bbcode("[right][i]" + Global.friendScore + "m")
		progressBar.set_max(int(Global.friendScore))
		$WorldLayer/FriendBeat/Label2.text = Global.friendName
		
		Global.track_event("ChallengeFriend")
	
	elif not Global.friendName and Global.highscore > 0:
		friendName.set_bbcode("[i]Your highscore: " + str(Global.highscore) + "m")
		progressBar.set_max(int(Global.highscore))
		$WorldLayer/FriendBeat/Label2.text = "Your highscore!"
	elif Global.highscore <= 0:
		progressBar.visible = false
		
	parallax.set_scroll_base_offset(Vector2(randomizeParallax(), 0))
	animation.play("FadeIn")
	
	Global.play_music(music_start)
	
	# Checks the current state of the music player
	sfxM.visible = Global.is_music_muted()
	sfxU.visible = not Global.is_music_muted()

func _process(delta):
	DTClouds.motion_offset.x += CLOUD_SPEED * delta
	DTFar.motion_offset.x += FAR_SPEED * delta
	DTMid.motion_offset.x += MID_SPEED * delta
	DTNear.motion_offset.x += NEAR_SPEED * delta
	DTCars.motion_offset.x += CARS_SPEED * delta
	crowd.motion_offset.x += -800 * delta

	if not gameEnd and not hasBeatScore:
		if displayText >= score_to_beat and score_to_beat > 0:
			hasBeatScore = true
			tween.interpolate_property($WorldLayer/FriendBeat, "position:y", -150.0, -30.0, 2.0, 10, Tween.EASE_OUT)
			tween.start()
			Global.play_music(music_new_record)
			$FriendBeatTimer.start()
			
#		elif displayText < score_to_beat and displayText == Global.HARD_MODE_THRESHOLD:
#			Global.play_music(music_harder)
	if not gameStart:
		time += delta * 2
		tap.scale = Vector2(amplitude * sin(time) + 1.3, amplitude * sin(time) + 1.3)
		if Input.is_action_just_pressed("tap"):
			tap.visible = false
			gameStart = true
	#$WorldLayer/PUtimer.rect_position.y += sin(time)
	if gameStart and not gameEnd:
		scoreText += delta * 7
		$WorldLayer/PUtimer.set_value(player.PUTimer.time_left)
	
		if Global.friendName and not scoreText > int(Global.friendScore):
			progressBar.set_value(scoreText)
		elif not Global.friendName and not scoreText > int(Global.highscore):
			progressBar.set_value(scoreText)
			
	displayText = floor(scoreText)
	score.text = str(displayText)
	
	if $WorldLayer/Hold.visible and not hasHeld:
		time += delta * 2
		$WorldLayer/Hold.scale = Vector2(amplitude * sin(time) + 1.3, amplitude * sin(time) + 1.3)
		if player.motion.y > 0 and player.jumpTDown == 1.5:
			hasHeld = true
			$WorldLayer/Hold.visible = false
	

#func _physics_process(delta):
#		if (int(displayText)%100) == 0 and not audio.playing and displayText > 99:
#			audio.stream = mSfx
#			audio.play()

func rand_ylevel():
	if gameStart:
		#Randomizes Y Level based on a randi from -3 to 3 multiplied by snapHeight
		ylevel = pastYlevel-((randi() % totalVariations - absoluteVariationsD) * snapHeight)
		
		if pastYlevel == ylevel and displayText >= Global.HARD_MODE_THRESHOLD: #If current Y Level is the same as the last Y Level
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
	else:
		return 448

func player_dies():
	$WorldLayer/PUtimer.visible = false
	$WorldLayer/Chicken.active = false
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
	
func player_picked_up_powerup(PUname):
	animation.stop()
	audio.stream = mSfx
	audio.play()
	player.powerUPStart(PUname)
	if PUname == "Glide":
		if not hasHeld:
			$WorldLayer/Hold.visible = true
		$WorldLayer/PUtimer.set_sprite()
		$WorldLayer/PUtimer.visible = true
		Global.play_music(music_harder)
		if Global.Character == Global.Kiko:
			$WorldLayer/Chicken.active = true

	
	
func _on_Area2D_area_entered(area):
	if area.name == "PlatHitBox":
		area.get_parent().position = Vector2(620, rand_ylevel())
		if gameStart:
			area.get_parent().powerup_chance()

func _on_DeathScreen_button_pressed(scene_path):
	audio.stream = buttonSfx
	audio.play()
	animation.play("FadeOut")
	scenePath = scene_path

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene(scenePath)


func _on_SFX_toggled(_button_pressed):
	audio.stream = buttonSfx
	audio.play()
	Global.toggle_mute()
	sfxM.visible = Global.is_music_muted()
	sfxU.visible = not Global.is_music_muted()


func _on_EXIT_button_down():
	audio.stream = buttonSfx
	audio.play()
	get_tree().paused = true
	if player.alive:
		confirmScr.displayScreen()
	elif not player.alive:
		deathScr.hideScreen()
		yield(get_tree().create_timer(0.7), "timeout")
		confirmScr.displayScreen()


func _on_CONFIRM_EXIT_button_down():
	audio.stream = buttonSfx
	audio.play()
	get_tree().paused = false
	player.playerDies()
	confirmScr.hideScreen()
	animation.play("FadeOut")
	scenePath = "res://src/Scenes/MainMenu.tscn"


func _on_CANCEL_button_down():
	audio.stream = buttonSfx
	audio.play()
	get_tree().paused = false
	confirmScr.hideScreen()
	if not player.alive:
		yield(get_tree().create_timer(0.7), "timeout")
		deathScr.displayScreen()


func _on_FriendBeatTimer_timeout():
	if not friendBeat:
		friendName.visible = false
		friendScore.visible = false
		progressBar.visible = false
		$FriendBeatTimer.start()
		friendBeat = true
	else:
		tween.interpolate_property($WorldLayer/FriendBeat, "position:y", -30.0, -150.0, 2.0, 10, Tween.EASE_IN)
		tween.start()


func _on_Player_toggleChicken(state):
	$WorldLayer/Chicken.active = state


func _on_Player_parolGet():
	scoreText += 50


func _on_PUTimer_timeout():
	$WorldLayer/PUtimer.visible = false
	Global.play_music(music_start)
