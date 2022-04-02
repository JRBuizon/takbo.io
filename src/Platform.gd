extends StaticBody2D

func _physics_process(_delta):
	position += Vector2(-2, 0.0)
	
	
func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_tree().reload_current_scene()
