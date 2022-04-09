extends StaticBody2D

var Speed = 0.0
var gameStart = false
var baseSpeed = -4.0

func _physics_process(delta):
	position += Vector2(Speed, 0.0)
	
	if not gameStart and Input.is_action_just_pressed("tap"):
		Speed = baseSpeed
		gameStart = true

func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().call_deferred("player_dies")
