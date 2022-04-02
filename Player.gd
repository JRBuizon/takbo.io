extends KinematicBody2D


var jumpHeight = 53.0
var jumpTUp = 0.3
var jumpTDown = 0.3

onready var jumpVelo = ((2.0 * jumpHeight) / jumpTUp) * -1
onready var jumpGrav = ((-2.0 * jumpHeight) / (jumpTUp * jumpTUp)) * -1
onready var fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1

var motion = Vector2.ZERO

func det_grav() -> float:
	return jumpGrav if motion.y < 0.0 else fallGrav

func _physics_process(delta):
	motion.y  += det_grav() * delta
	
	if is_on_floor():
		#Play Run animation
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jumpVelo
	else:
		#Play Jump animation
		if Input.is_action_just_released("ui_up") and motion.y < jumpVelo/2:
			motion.y = jumpVelo/2
	
	motion = move_and_slide(motion, Vector2.UP)
	
	
	
	

