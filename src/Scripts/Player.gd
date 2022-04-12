extends KinematicBody2D


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

func _ready():
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
	if Global.Leni:
		$LeniSprite.visible = true
		$KikoSprite.visible = false
	else:
		$LeniSprite.visible = false
		$KikoSprite.visible = true
	

func _physics_process(delta):
	motion.y  += det_grav() * delta
	if alive:
		if floorCast.is_colliding() or is_on_floor():
			animation.play("Run")
			if Input.is_action_just_pressed("tap"):
				audio.stream = jumpSfx
				audio.play()
				motion.y = jumpVelo
		else:
			if motion.y < 0:
				animation.play("Jump")
			else:
				animation.play("Falling")
			
			if Input.is_action_just_released("tap") and motion.y < jumpVelo/2:
					motion.y = jumpVelo/2
	
	motion = move_and_slide(motion, Vector2.UP)
	


