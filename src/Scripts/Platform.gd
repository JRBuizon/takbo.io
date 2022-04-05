extends StaticBody2D

var Speed = 0.0
var gameStart = false
var baseSpeed = -2.0

func _physics_process(delta):
	position += Vector2(Speed, 0.0)
	
	if Input.is_action_just_pressed("ui_up") and not gameStart:
		Speed = baseSpeed
		gameStart = true

func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().call_deferred("Player_dies")
		#get_tree().reload_current_scene()
		pass
