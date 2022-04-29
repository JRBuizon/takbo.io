extends Node2D




func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().get_parent().get_parent().call_deferred("player_picked_up_powerup", "Glide")
		self.queue_free()
