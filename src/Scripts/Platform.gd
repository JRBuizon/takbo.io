extends StaticBody2D

var Speed = -4.0
var powerUpChance = 0.0
var PUthreshold = 0.50

var glidePU = preload("res://src/Scenes/GlidePower.tscn")
var parolPU = preload("res://src/Scenes/Parol.tscn")

func powerup_chance():
	powerUpChance = randf()
	if powerUpChance >= PUthreshold:
		var choice = randi() % 5
		if choice == 0:
			var glideInst = glidePU.instance()
			glideInst.position = Vector2(0, -20)
			self.add_child(glideInst)
		else:
			var parolInst = parolPU.instance()
			parolInst.position = Vector2(0, (randi()%6 + 1) * -30)
			self.add_child(parolInst)

func _physics_process(delta):
	position += Vector2(-4.0, 0.0)

func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().get_parent().call_deferred("player_dies")
