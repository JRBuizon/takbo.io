extends Node2D

onready var tween = $Tween
onready var nameInput = $FirstPanel/LineEdit
var amplitude = 3
var time = 0

onready var link = "https://takbo-io-demo.vercel.app/?name=friend&score=" + str(Global.highscore)

func _ready():
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$FirstPanel/Label2.text = str(Global.score)
	
func _process(delta):
	time += delta * 2
	$TakboLogo.position = Vector2(240, amplitude * sin(time) + 163)

func _on_SHARE_button_down():
	link = "https://takbo-io-demo.vercel.app/?name=" + nameInput.text + "&score=" + str(Global.highscore)
	tween.interpolate_property($SecondPanel, "position",
		Vector2(500, 0), Vector2(-500, 0), 2,
		10, Tween.EASE_OUT_IN)
	tween.start()
	
	OS.set_clipboard(link)


func _on_EXIT_button_down():
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$Timer.start()
	


func _on_Timer_timeout():
	get_tree().change_scene("res://src/Scenes/MainMenu.tscn")
