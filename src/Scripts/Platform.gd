extends StaticBody2D

var Speed = -4.0

func _physics_process(delta):
	position += Vector2(-4.0, 0.0)

func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().call_deferred("player_dies")
