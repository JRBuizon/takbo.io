extends KinematicBody2D


onready var collision = $PlayerColl
onready var hitBox = $PlayerHitBox
onready var sprite = $PlayerSprite
onready var floorCast = $floorRayCast

var jumpHeight = 48.0
var jumpTUp = 0.25
var jumpTDown = 0.2

onready var jumpVelo = ((2.0 * jumpHeight) / jumpTUp) * -1
onready var jumpGrav = ((-2.0 * jumpHeight) / (jumpTUp * jumpTUp)) * -1
onready var fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1

onready var leniSprite = preload("res://placeHolderRed.png")
onready var kikoSprite = preload("res://placeHolderWhite.png")


var motion = Vector2.ZERO
var alive = true

func _ready():
	collision.disabled = false
	hitBox.monitoring = true
	setSprite()

func det_grav() -> float:
	return jumpGrav if motion.y < 0.0 else fallGrav

func playerDies():
	#Play death animation
	collision.disabled = true
	hitBox.monitoring = false
	alive = false
	pass

func setSprite():
	if Global.Leni:
		sprite.set_texture(leniSprite)
	else:
		sprite.set_texture(kikoSprite)
	

func _physics_process(delta):
	motion.y  += det_grav() * delta
	if alive:
		if floorCast.is_colliding() or is_on_floor():
			#Play Run animation
			if Input.is_action_just_pressed("ui_up"):
				motion.y = jumpVelo
		else:
			#Play Jump animation
			if Input.is_action_just_released("ui_up") and motion.y < jumpVelo/2:
				motion.y = jumpVelo/2
	
	motion = move_and_slide(motion, Vector2.UP)
	
	
	
	

