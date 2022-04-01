extends KinematicBody2D


const ACCELERATION = 512
const MAXSPEED = 64
const FRICTION = 0.25
const GRAVITY = 200
const DOWN_GRAV = 400
const JUMP_FORCE = 128

var motion = Vector2.ZERO

func _physics_process(delta):
	
	motion.y += GRAVITY * delta
	
	
	
	if is_on_floor():
		#Play Run animation
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		#Play Jump animation
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2

	motion = move_and_slide(motion, Vector2.UP)
