extends StaticBody2D

var Speed = -4.0
var powerUpChance = 0.0
var PUthreshold = 0.5

var glidePU = preload("res://src/Scenes/GlidePower.tscn")
#var coinPU = preload("")

func powerup_chance():
	powerUpChance = randf()
	if powerUpChance >= PUthreshold and Global.hasPU == false:
		var choice = randi() % 3
		if choice == 0:
			var glideInst = glidePU.instance()
			glideInst.position = Vector2(0, -30)
			self.add_child(glideInst)
		elif choice == 1:
			#var coinInst = coinPU.instance()
			pass
		elif choice == 2:
			pass
		

func _physics_process(delta):
	position += Vector2(-4.0, 0.0)

func _on_PlatHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().get_parent().call_deferred("player_dies")
