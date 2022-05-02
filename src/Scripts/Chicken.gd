extends KinematicBody2D


var jumpHeight = 105.0
var jumpTUp = 0.25
var jumpTDown = 0.2

onready var jumpVelo = ((2.0 * jumpHeight) / jumpTUp) * -1
onready var jumpGrav = ((-2.0 * jumpHeight) / (jumpTUp * jumpTUp)) * -1
onready var fallGrav = ((-2.0 * jumpHeight) / (jumpTDown * jumpTDown)) * -1

onready var animation = $AnimationPlayer

var motion = Vector2.ZERO
var active = false

func det_grav() -> float:
	return jumpGrav if motion.y < 0.0 else fallGrav


func _process(_delta):
	if active:
		$Sprite.visible = true
	else:
		$Sprite.visible = false

func _physics_process(delta):
	motion.y  += det_grav() * delta
	if is_on_floor():
		animation.play("Run")
		if $incomingWall.is_colliding() or not $holeAhead.is_colliding():
			motion.y = jumpVelo
	else:
		animation.play("Flying")
	motion = move_and_slide(motion, Vector2.UP)
