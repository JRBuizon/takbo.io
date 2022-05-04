extends KinematicBody2D

signal toggleChicken(state)
signal parolGet()

onready var collision = $PlayerColl
onready var hitBox = $PlayerHitBox
onready var hitBoxCol = $PlayerHitBox/CollisionShape2D
onready var floorCast = $floorRayCast
onready var animation = $AnimationPlayer

var deathSfx = preload("res://src/Assets/Sounds/SFX/deathv1.mp3")
var jumpSfx = preload("res://src/Assets/Sounds/SFX/jumpv2.mp3")
var yoda = preload("res://src/Assets/Sounds/THIS IS SUPER IMPORTANT DO NOT DELETE.mp3")

var jumpHeight = 105.0
var jumpTUp = 0.25
var jumpTDown = 0.2

onready var jumpVelo = ((2.0 * jumpHeight) / jumpTUp) * -1
onready var jumpGrav = ((-2.0 * jumpHeight) / (jumpTUp * jumpTUp)) * -1
onready var fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1

var motion = Vector2.ZERO
var alive = true
var audio: AudioStreamPlayer

onready var PUTimer = $PUTimer
var glide = false

func powerUPStart(PUname):
	#apply powerups here
	if PUname == "Parol":
		$Tween.interpolate_property($GabSprite, "rotation_degrees", 0.0, 360.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		emit_signal("parolGet")
	
	if PUname == "Glide":
		$GabSprite.material.set_shader_param("is_rainbow", true)
		Global.hasPU = true
		glide = true
		PUTimer.start()
	

func _ready():
	$GabSprite.material.set_shader_param("is_rainbow", false)
	audio = AudioStreamPlayer.new()
	audio.volume_db = -10
	add_child(audio)
	collision.disabled = false
	hitBox.monitoring = true
	hitBoxCol.disabled = false
	setSprite()

func det_grav() -> float:
	return jumpGrav if motion.y < 0.0 else fallGrav

func playerDies():
	$GabSprite.material.set_shader_param("is_rainbow", false)
	jumpTDown = 0.2
	fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1
	var willYoda = randf() #0-1
	if willYoda > 0.98:
		audio.volume_db = -30
		audio.stream = yoda
		audio.play()
	else:
		audio.volume_db = -10
		audio.stream = deathSfx
		audio.play()
		
	collision.disabled = true
	hitBox.monitoring = false
	hitBoxCol.disabled = true
	animation.play("Dizzy")
	fallGrav = fallGrav/5
	$Tween.interpolate_property(self, "rotation_degrees", 0.0, 180.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	alive = false
	pass

func setSprite():
	if Global.Character == Global.Leni:
		$LeniSprite.visible = true #CHANGE THIS BACK TO TRUE AFTER TESTING CHICKEN
		$KikoSprite.visible = false
		$GabSprite.visible = false
	elif Global.Character == Global.Kiko:
		$LeniSprite.visible = false
		$KikoSprite.visible = true
		$GabSprite.visible = false
	elif Global.Character == Global.Gab:
		$LeniSprite.visible = false
		$KikoSprite.visible = false
		$GabSprite.visible = true

func _physics_process(delta):
	motion.y  += det_grav() * delta
	if alive:
		if floorCast.is_colliding() or is_on_floor():
			if glide and Global.Character == Global.Kiko:
				emit_signal("toggleChicken", true)
			animation.play("Run")
			if Input.is_action_just_pressed("tap"):
				if glide:
					jumpTDown = 1.5
					fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1
				audio.stream = jumpSfx
				audio.play()
				motion.y = jumpVelo
		else:
			if motion.y < 0:
				animation.play("Jump")
			elif motion.y > 0 and not jumpTDown == 1.5:
				animation.play("Falling")
			elif motion.y > 0 and jumpTDown == 1.5:
				emit_signal("toggleChicken", false)
				animation.play("Gliding")
			
			if Input.is_action_just_released("tap") and motion.y < jumpVelo/2:
				motion.y = jumpVelo/2

		if Input.is_action_just_released("tap"):
			if glide and Global.hasPU and Global.Character == Global.Kiko:
				emit_signal("toggleChicken", true)
#			elif not glide and not Global.Leni:
#				emit_signal("toggleChicken", false)
			jumpTDown = 0.2
			fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1
	
	motion = move_and_slide(motion, Vector2.UP)
	




func _on_PUTimer_timeout():
	#Get rid of powerup here
	$GabSprite.material.set_shader_param("is_rainbow", false)
	Global.hasPU = false
	glide = false
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("toggleChicken", false)
	pass
