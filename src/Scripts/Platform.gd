extends StaticBody2D

var Speed = 0.0
var gameStart = false
var baseSpeed = -5.0


func _physics_process(delta):
	position += Vector2(Speed, 0.0)
	
	if Input.is_action_just_pressed("tap") and not gameStart:
		Speed = baseSpeed
		gameStart = true

func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().call_deferred("player_dies")
