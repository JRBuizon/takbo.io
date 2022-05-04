extends Node2D

var time = 0
var speed = 3
var amplitude = 20

func _ready():
	if Global.Character == Global.Leni:
		$Ribbon.frame = 0
	elif Global.Character == Global.Kiko:
		$Ribbon.frame = 1
	elif Global.Character == Global.Gab:
		$Ribbon.frame = 4
		
func _process(delta):
	time += delta * speed
	$Ribbon.rotation_degrees = amplitude * sin(time)
	self.position.y += amplitude/20 * sin(time)

func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		get_parent().get_parent().get_parent().call_deferred("player_picked_up_powerup", "Glide")
		self.queue_free()
